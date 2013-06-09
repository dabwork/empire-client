// Copyright (C) 2013 Elemental Games. All rights reserved.

package Empire
{

public class HangarUnit
{
	static public const SlotMax:int = 32;

	public var m_HangarId:uint = 0;
	public var m_Anm:uint = 0;
	public var m_Hull:uint = 0;
	public var m_Sort:int = 0;

	public var m_Slot:Vector.<HangarSlot> = new Vector.<HangarSlot>();

	public var m_LoadAfterAnm:uint = 0;
	public var m_LoadAfterAnm_Time:Number = 0;
	public var m_Tmp:uint = 0;
	
	static private var m_IdxList:Vector.<int> = new Vector.<int>(SlotMax, true);
	static private var m_GroupEnergy:Vector.<int> = new Vector.<int>(SlotMax, true);

	public function HangarUnit():void
	{
		var i:int;
		for (i = 0; i < SlotMax; i++) m_Slot.push(new HangarSlot());
	}

	//[Inline]
	final public function SlotClear():void
	{
		var i:int;
		var s:HangarSlot;
		for (i = 0; i < SlotMax; i++) {
			s = m_Slot[i];
			s.m_Type = 0;
			s.m_X = 0;
			s.m_Y = 0;
			s.m_ItemType = 0;
			s.m_ItemCnt = 0;
			s.m_ItemBroken = 0;
		}
	}

	public function CalcPar():void
	{
		CalcEnergy();
	}

	public function CalcEnergy():void
	{
		var i:int, u:int, g:int, k:int, off:int, cnt:int, r:int, rc:int, e:int;
		var s:HangarSlot, s2:HangarSlot;
		var idesc:Item;

		for (i = 0; i < SlotMax; i++) {
			s = m_Slot[i];
			s.m_Group = 0;
			s.m_Energy = 0;

			if (!s.m_Type) continue;
			if (!s.m_ItemType) continue;

			idesc = UserList.Self.GetItem(s.m_ItemType);
			if (!idesc) continue;
			if (!idesc.IsEq()) continue;

			for (u = 0; u < Item.BonusCnt; u++) {
				if (idesc.m_BonusType[u] != Common.ItemBonusEnergy) continue;
				k = (s.m_ItemType >> (16 + idesc.m_CoefShift[u])) & ((1 << idesc.m_CoefBit[u]) - 1);
				if (k >= idesc.m_CoefCnt[u]) k = idesc.m_CoefCnt[u] - 1;
				s.m_Energy = idesc.m_Coef[u * Item.CoefCnt + k];
			}
		}

		// Группируем энергетические слоты
		g = 0;
		for (i = 0; i < SlotMax; i++) {
			s = m_Slot[i];
			if (s.m_Type != Hangar.stEnergy) continue;
			if (s.m_Group) continue;

			g++;
			s.m_Group = 1 << (g - 1);

			cnt = 0;
			off = 0;
			m_IdxList[cnt++] = i;
			e = s.m_Energy;

			while (off < cnt) {
				u = m_IdxList[off++];
				s = m_Slot[u];

				for (k = 0; k < SlotMax; k++) {
					if (u == k) continue;
					s2 = m_Slot[k];
					if (s2.m_Type != Hangar.stEnergy) continue;
					if (s2.m_Group) continue;

					r = (s.m_X - s2.m_X) * (s.m_X - s2.m_X) + (s.m_Y - s2.m_Y) * (s.m_Y - s2.m_Y);
					rc = Hangar.slotRadius[s.m_Type] + Hangar.slotRadius[s2.m_Type] + 4;
					if (r > rc * rc) continue;

					s2.m_Group = 1 << (g - 1);
					m_IdxList[cnt++] = k;
					e += s2.m_Energy;
				}
			}

			for (k = 0; k < SlotMax; k++) {
				s2 = m_Slot[k];
				if (s2.m_Type != Hangar.stEnergy) continue;
				if (s2.m_Group != (1 << (g - 1))) continue;

				s2.m_Energy = e;
			}
			m_GroupEnergy[g - 1] = e;
		}

		// Помечаем у ядер к каким они группам присоединены
		for (i = 0; i < SlotMax; i++) {
			s = m_Slot[i];
			if (s.m_Type != Hangar.stCore) continue;

			for (k = 0; k < SlotMax; k++) {
				s2 = m_Slot[k];
				if (s2.m_Type != Hangar.stEnergy) continue;
				if (!s2.m_Group) continue;

				r = (s.m_X - s2.m_X) * (s.m_X - s2.m_X) + (s.m_Y - s2.m_Y) * (s.m_Y - s2.m_Y);
				rc = Hangar.slotRadius[s.m_Type] + Hangar.slotRadius[s2.m_Type] + 4;
				if (r > rc * rc) continue;

				s.m_Group |= s2.m_Group;
			}
		}

		// Помечаем потребители заряда к каким ядрам они присоединены
		for (i = 0; i < SlotMax; i++) {
			s = m_Slot[i];
			if (s.m_Type != Hangar.stCharge) continue;

			for (k = 0; k < SlotMax; k++) {
				s2 = m_Slot[k];
				if (s2.m_Type != Hangar.stCore) continue;

				r = (s.m_X - s2.m_X) * (s.m_X - s2.m_X) + (s.m_Y - s2.m_Y) * (s.m_Y - s2.m_Y);
				rc = Hangar.slotRadius[s.m_Type] + Hangar.slotRadius[s2.m_Type] + 4;
				if (r > rc * rc) continue;

				s.m_Group |= 1 << k;
			}
		}
		
		// Переносим излишек энергии на ядра
		for (i = 0; i < g; i++) {
			if (m_GroupEnergy[i] <= 0) continue;

			cnt = 0;
			for (k = 0; k < SlotMax; k++) {
				s = m_Slot[k];
				if (s.m_Type != Hangar.stCore) continue;
				if (!s.m_ItemType) continue;
				
				if (!(s.m_Group & (1 << i))) continue;
				cnt++;
			}
			if (cnt <= 0) continue;

			e = Math.floor(m_GroupEnergy[i] / cnt);
			r = m_GroupEnergy[i] % cnt;

			cnt = 0;
			for (k = 0; k < SlotMax; k++) {
				s = m_Slot[k];
				if (s.m_Type != Hangar.stCore) continue;
				if (!s.m_ItemType) continue;

				if (!(s.m_Group & (1 << i))) continue;
				s.m_Energy += e;
				if (cnt < r) s.m_Energy++;
				cnt++;
			}
		}
		
		// Потребители заряда забирают энергию из ядра
		for (i = 0; i < SlotMax; i++) {
			s = m_Slot[i];
			if (s.m_Type != Hangar.stCharge) continue;
			if (s.m_Energy >= 0) continue;

			e = 0;
			for (k = 0; k < SlotMax; k++) {
				if (!(s.m_Group & (1 << k))) continue;
				s2 = m_Slot[k];
				if (s2.m_Energy <= 0) continue;
				e += s2.m_Energy;
			}

			r = -s.m_Energy;
			if (r > e) r = e;

			for (k = 0; k < SlotMax; k++) {
				if (!(s.m_Group & (1 << k))) continue;
				s2 = m_Slot[k];
				if (s2.m_Energy <= 0) continue;
				u = Math.floor((r * s2.m_Energy) / e);
				if (u <= 0) continue;
				s2.m_Energy -= u;
				s.m_Energy += u;
			}

			e = 1;
			while (s.m_Energy < 0 && e) {
				e = 0;
				for (k = 0; (k < SlotMax) && (s.m_Energy < 0); k++) {
					if (!(s.m_Group & (1 << k))) continue;
					s2 = m_Slot[k];
					if (s2.m_Energy <= 0) continue;
					s2.m_Energy--;
					s.m_Energy++;
					e = 1;
				}
			}
		}
	}
}
	
}