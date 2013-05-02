package Base3D
{
	
public class Bos
{
	public var m_ObjCnt:int = 0;
	public var m_ObjFirst:BosObj = null;
	public var m_ObjLast:BosObj = null;
	
	public var m_ObjEmptyFirst:BosObj = null;
	public var m_ObjEmptyLast:BosObj = null;
	
	public var m_NodeRoot:BosNode = null;
	public var m_NodeEmptyFirst:BosNode = null;
	public var m_NodeEmptyLast:BosNode = null;
	
	public function Bos():void
	{
	}
	
	public function ClearFull():void
	{
		Clear();
		
		var obj:BosObj;
		var objnext:BosObj = m_ObjEmptyFirst;
		while (objnext != null) {
			obj = objnext;
			objnext = objnext.m_ObjNext;
			
			obj.Clear();
		}
		m_ObjEmptyFirst = null;
		m_ObjEmptyLast = null;

		var node:BosNode;
		var nodenext:BosNode = m_NodeEmptyFirst;
		while (nodenext != null) {
			node = nodenext;
			nodenext = nodenext.m_Back;
			
			node.Clear();
		}
		m_NodeEmptyFirst = null;
		m_NodeEmptyLast = null;
	}
	
	public function Clear():void
	{
		if (m_ObjFirst != null) {
			var obj:BosObj;
			var objnext:BosObj = m_ObjFirst;
			while (objnext != null) {
				obj = objnext;
				objnext = objnext.m_ObjNext;
				
				obj.m_ObjPrev = m_ObjEmptyLast;
				obj.m_ObjNext = null;
				if (m_ObjEmptyLast != null) { m_ObjEmptyLast.m_ObjNext = obj; }
				m_ObjEmptyLast = obj;
				if (m_ObjEmptyFirst == null) { m_ObjEmptyFirst = obj; }
			}
		}

		m_ObjFirst=null;
		m_ObjLast=null;
		m_ObjCnt=0;

		if(m_NodeRoot!=null) { ClearNode(m_NodeRoot); NodeFree(m_NodeRoot); m_NodeRoot=null; }
	}
	
	public function ClearNode(node:BosNode):void
	{
		if (node.m_Front != null) {
			ClearNode(node.m_Front);
			NodeFree(node.m_Front);
			node.m_Front = null;
		} 
		if (node.m_Back != null) {
			ClearNode(node.m_Back);
			NodeFree(node.m_Back);
			node.m_Back = null;
		}
	}

	public function ObjAlloc():BosObj
	{
		var obj:BosObj = m_ObjEmptyLast;
		if (obj != null) {
			if (obj.m_ObjPrev != null) obj.m_ObjPrev.m_ObjNext = obj.m_ObjNext;
			if (obj.m_ObjNext != null) obj.m_ObjNext.m_ObjPrev = obj.m_ObjPrev;
			if (m_ObjEmptyLast == obj) m_ObjEmptyLast = obj.m_ObjPrev;
			if (m_ObjEmptyFirst == obj) m_ObjEmptyFirst = obj.m_ObjNext;

		} else {
			obj = new BosObj();
		}
		obj.Clear();
		return obj;
	}

	public function ObjFree(obj:BosObj):void
	{
		obj.Clear();
		
		obj.m_ObjPrev = m_ObjEmptyLast;
		obj.m_ObjNext = null;
		if (m_ObjEmptyLast != null) { m_ObjEmptyLast.m_ObjNext = obj; }
		m_ObjEmptyLast = obj;
		if (m_ObjEmptyFirst == null) { m_ObjEmptyFirst = obj; }
	}
	
	public function NodeAlloc():BosNode
	{
		var node:BosNode = m_NodeEmptyLast;
		if (node != null) {
			if (node.m_Front != null) node.m_Front.m_Back = node.m_Back;
			if (node.m_Back != null) node.m_Back.m_Front = node.m_Front;
			if (m_NodeEmptyLast == node) m_NodeEmptyLast = node.m_Front;
			if (m_NodeEmptyFirst == node) m_NodeEmptyFirst = node.m_Back;
			
		} else {
			node = new BosNode();
		}
		node.Clear();
		return node;
	}

	public function NodeFree(node:BosNode):void
	{
		node.Clear();
		
		node.m_Front = m_NodeEmptyLast;
		node.m_Back = null;
		if (m_NodeEmptyLast != null) { m_NodeEmptyLast.m_Back = node; }
		m_NodeEmptyLast = node;
		if (m_NodeEmptyFirst == null) { m_NodeEmptyFirst = node; }
	}
	
	static public function NodeFindLast(posx:Number, posy:Number, posz:Number, node:BosNode):BosNode
	{
		var cf:int = node.Classify(posx, posy, posz);
		if(cf>=0) {
			if (node.m_Front == null) return node;
			return NodeFindLast(posx, posy, posz, node.m_Front);
		} else {
			if (node.m_Back == null) return node;
			return NodeFindLast(posx, posy, posz, node.m_Back);
		}
	}

	public function ObjAdd(posx:Number, posy:Number, posz:Number, r:Number):BosObj
	{
		var k:Number;
		var node:BosNode = null;
		var nt:BosNode;
		
		var obj:BosObj = ObjAlloc();
		m_ObjCnt++;
		obj.m_X = posx;
		obj.m_Y = posy;
		obj.m_Z = posz;
		obj.m_Node = null;
		obj.m_Radius = r;
		
		obj.m_ObjPrev = m_ObjLast;
		obj.m_ObjNext = null;
		if (m_ObjLast != null) { m_ObjLast.m_ObjNext = obj; }
		m_ObjLast = obj;
		if (m_ObjFirst == null) { m_ObjFirst = obj; }

		if (m_ObjCnt <= 1) return obj;
		
		if(m_NodeRoot==null) {
			node = m_NodeRoot = NodeAlloc();
			m_NodeRoot.m_Front = null;
			m_NodeRoot.m_Back = null;

			m_NodeRoot.m_ObjFront = m_ObjFirst;
			m_NodeRoot.m_ObjBack = obj;
			m_ObjFirst.m_Node = m_NodeRoot;
			obj.m_Node = m_NodeRoot;

		} else {
			node=NodeFindLast(posx,posy,posz,m_NodeRoot);
			var cf:int = node.Classify(posx,posy,posz);
			if (cf >= 0) {
				if (node.m_ObjFront == null) {
					node.m_ObjFront = obj;
					obj.m_Node = node;
					return obj;
				} else {
					nt = node.m_Front = NodeAlloc();
					nt.m_Front = null;
					nt.m_Back = null;

					nt.m_ObjFront = node.m_ObjFront;
					node.m_ObjFront = null;
					nt.m_ObjBack = obj;
					nt.m_ObjFront.m_Node = nt;
					nt.m_ObjBack.m_Node = nt;

					node=nt;
				}
			} else {
				if (node.m_ObjBack == null) {
					node.m_ObjBack = obj;
					obj.m_Node = node;
					return obj;
				} else {
					nt = node.m_Back = NodeAlloc();
					nt.m_Front = null;
					nt.m_Back = null;

					nt.m_ObjFront = node.m_ObjBack;
					node.m_ObjBack = null;
					nt.m_ObjBack = obj;
					nt.m_ObjFront.m_Node = nt;
					nt.m_ObjBack.m_Node = nt;

					node = nt;
				}
			}
		}

		var nx:Number = node.m_ObjFront.m_X - node.m_ObjBack.m_X;
		var ny:Number = node.m_ObjFront.m_Y - node.m_ObjBack.m_Y;
		var nz:Number = node.m_ObjFront.m_Z - node.m_ObjBack.m_Z;
		var d:Number = nx * nx + ny * ny + nz * nz;
		if (d < 0.0001) {
			nx = 0.577350269189626;
			ny = 0.577350269189626;
			nz = 0.577350269189626;
			d = 0.0;
		} else {
			d = Math.sqrt(d);
			k = 1.0 / d;
			nx *= k; ny *= k; nz *= k;
		}
		if (d < node.m_ObjFront.m_Radius + node.m_ObjBack.m_Radius) d *= 0.5;// Нужно изменить на расстояние до плоскости пресечения
		else d = node.m_ObjBack.m_Radius + (d - node.m_ObjFront.m_Radius - node.m_ObjBack.m_Radius) * 0.5; // Среднее расстояние между объектами

		var px:Number = node.m_ObjBack.m_X + nx * d;
		var py:Number = node.m_ObjBack.m_Y + ny * d;
		var pz:Number = node.m_ObjBack.m_Z + nz * d;

		node.m_A = nx;
		node.m_B = ny;
		node.m_C = nz;
		node.m_D = -(nx * px + ny * py + nz * pz);

		return obj;
	}

	public function SortR(posx:Number, posy:Number, posz:Number, node:BosNode):void
	{
		var obj:BosObj;
		var cf:int = node.Classify(posx, posy, posz);
		if (cf >= 0) {
			if (node.m_ObjFront != null) {
				obj = node.m_ObjFront;

				obj.m_ObjPrev = m_ObjLast;
				obj.m_ObjNext = null;
				if (m_ObjLast != null) { m_ObjLast.m_ObjNext = obj; }
				m_ObjLast = obj;
				if (m_ObjFirst == null) { m_ObjFirst = obj; }

			} else if (node.m_Front != null) {
				SortR(posx, posy, posz, node.m_Front);
			}
			if (node.m_ObjBack != null) {
				obj = node.m_ObjBack;

				obj.m_ObjPrev = m_ObjLast;
				obj.m_ObjNext = null;
				if (m_ObjLast != null) { m_ObjLast.m_ObjNext = obj; }
				m_ObjLast = obj;
				if (m_ObjFirst == null) { m_ObjFirst = obj; }

			} else if (node.m_Back != null) {
				SortR(posx, posy, posz, node.m_Back);
			}
		} else {
			if (node.m_ObjBack != null) {
				obj = node.m_ObjBack;

				obj.m_ObjPrev = m_ObjLast;
				obj.m_ObjNext = null;
				if (m_ObjLast != null) { m_ObjLast.m_ObjNext = obj; }
				m_ObjLast = obj;
				if (m_ObjFirst == null) { m_ObjFirst = obj; }

			} else if (node.m_Back != null) {
				SortR(posx, posy, posz, node.m_Back);
			}
			if (node.m_ObjFront != null) {
				obj = node.m_ObjFront;

				obj.m_ObjPrev = m_ObjLast;
				obj.m_ObjNext = null;
				if (m_ObjLast != null) { m_ObjLast.m_ObjNext = obj; }
				m_ObjLast = obj;
				if (m_ObjFirst == null) { m_ObjFirst = obj; }

			} else if (node.m_Front != null) {
				SortR(posx, posy, posz, node.m_Front);
			}
		}
	}
	
	public function Sort(posx:Number, posy:Number, posz:Number):void
	{
		if (m_ObjCnt <= 1) return;

		m_ObjFirst = null;
		m_ObjLast = null;

		SortR(posx, posy, posz, m_NodeRoot);
	}
}
	
}