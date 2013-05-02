package B3DEffect
{
import Base.*;
import Engine.*;

public class EmitterStyle
{
	public var m_Frame:Vector.<EmitterFrame> = new Vector.<EmitterFrame>();
	
	// Картинка
	public var m_Img:String = "";
	public var m_ImgCenterX:Number = 0.0;
	public var m_ImgCenterY:Number = 0.0;
	public var m_ImgScaleX:Number = 1.0;
	public var m_ImgScaleY:Number = 1.0;
	public var m_ImgRnd:Boolean = false;
	public var m_ImgAnim:Boolean = false;
	public var m_ImgSpeed:Number = 25; // количество кадров в секунду если ролик. иначе скорость изменения текстурных координат
	public var m_ImgDist:Number = 0; // достанция повторения текстурных координат. 0-не зависит от высоты

	// Позиция испускаемых частиц
	public var m_PosType:int = 0; // 0-от центра 1-от плоскости перпендикулярной экрану 2-от плоскости перпендикулярной направлению 3-от плоскости перпендикулярной нормали
	public var m_PosPath:Number = 0.0;

	// для плоскости - радиус появления частиц от центра
	public var m_RadiusIV:Number = 0.0; 
	public var m_RadiusID:Number = 0.0;
	public var m_RadiusIG:Vector.<Number> = new Vector.<Number>();
	public var m_RadiusRV:Number = 0.0;
	public var m_RadiusRD:Number = 0.0;
	public var m_RadiusRG:Vector.<Number> = new Vector.<Number>();
	public var m_RadiusAAdd:Number = 1.0;
	public var m_RadiusAMul:Number = 0.0;
	public var m_RadiusAPow:Number = 1.0;
	public var m_RadiusBAdd:Number = 1.0;
	public var m_RadiusBMul:Number = 0.0;
	public var m_RadiusBPow:Number = 1.0;

	// Угол направления полета частиц
	public var m_AngleIV:Number = 0.0;
	public var m_AngleID:Number = 0.0;
	public var m_AngleIG:Vector.<Number> = new Vector.<Number>();
	public var m_AngleRV:Number = 0.0;
	public var m_AngleRD:Number = 180.0;
	public var m_AngleRG:Vector.<Number> = new Vector.<Number>();

	// Угол направления полета частиц
	public var m_RotateIV:Number = 0.0;
	public var m_RotateID:Number = 0.0;
	public var m_RotateIG:Vector.<Number> = new Vector.<Number>();
	public var m_RotateRV:Number = -180.0;
	public var m_RotateRD:Number = 360.0;
	public var m_RotateRG:Vector.<Number> = new Vector.<Number>();

	// Смещение частицы к экрану
	public var m_OffsetIV:Number = 0.0; 
	public var m_OffsetID:Number = 0.0;
	public var m_OffsetIG:Vector.<Number> = new Vector.<Number>();
	public var m_OffsetRV:Number = 0.0;
	public var m_OffsetRD:Number = 0.0;
	public var m_OffsetRG:Vector.<Number> = new Vector.<Number>();
	public var m_OffsetOV:Number = 0.0;
	public var m_OffsetOD:Number = 0.0;
	public var m_OffsetOG:Vector.<Number> = new Vector.<Number>();
	public var m_OffsetAAdd:Number = 1.0;
	public var m_OffsetAMul:Number = 0.0;
	public var m_OffsetAPow:Number = 1.0;
	public var m_OffsetBAdd:Number = 1.0;
	public var m_OffsetBMul:Number = 0.0;
	public var m_OffsetBPow:Number = 1.0;

	// Период испускания частиц от начала.
	public var m_Period:int = 1000; // 0 - единомоментное появление частиц
	
	// Зацикленость испускания частиц
	public var m_Loop:Boolean = false;
	
	// Создание частиц в перво кадре. Если m_Loop=true то частицы не удаляются и не создаются.
	public var m_FirstFrame:Boolean = false;

	// Количество частиц в секунду
	public var m_AmountIV:Number = 10.0;
	public var m_AmountID:Number = 0.0;
	public var m_AmountIG:Vector.<Number> = new Vector.<Number>();
	public var m_AmountRV:Number = 0.0;
	public var m_AmountRD:Number = 0.0;
	public var m_AmountRG:Vector.<Number> = new Vector.<Number>();
	public var m_AmountAAdd:Number = 1.0;
	public var m_AmountAMul:Number = 0.0;
	public var m_AmountAPow:Number = 1.0;
	public var m_AmountBAdd:Number = 1.0;
	public var m_AmountBMul:Number = 0.0;
	public var m_AmountBPow:Number = 1.0;

	// Время жизни частицы
	public var m_LifeIV:Number = 1000.0;
	public var m_LifeID:Number = 0.0;
	public var m_LifeIG:Vector.<Number> = new Vector.<Number>();
	public var m_LifeRV:Number = 0.0;
	public var m_LifeRD:Number = 0.0;
	public var m_LifeRG:Vector.<Number> = new Vector.<Number>();
	public var m_LifeAAdd:Number = 1.0;
	public var m_LifeAMul:Number = 0.0;
	public var m_LifeAPow:Number = 1.0;
	public var m_LifeBAdd:Number = 1.0;
	public var m_LifeBMul:Number = 0.0;
	public var m_LifeBPow:Number = 1.0;

	// Ширина частицы
	public var m_WidthType:int = 0; // 0-world 1-screen
	public var m_WidthIV:Number = 100.0;
	public var m_WidthID:Number = 0.0;
	public var m_WidthIG:Vector.<Number> = new Vector.<Number>();
	public var m_WidthRV:Number = 0.0;
	public var m_WidthRD:Number = 0.0;
	public var m_WidthRG:Vector.<Number> = new Vector.<Number>();
	public var m_WidthOV:Number = 0.0;
	public var m_WidthOD:Number = 0.0;
	public var m_WidthOG:Vector.<Number> = new Vector.<Number>();
	public var m_WidthAAdd:Number = 1.0;
	public var m_WidthAMul:Number = 0.0;
	public var m_WidthAPow:Number = 1.0;
	public var m_WidthBAdd:Number = 1.0;
	public var m_WidthBMul:Number = 0.0;
	public var m_WidthBPow:Number = 1.0;

	// Высота частицы
	public var m_HeightType:int = 0; // 0-=Width 1-target
/*	public var m_HeightType:int = 3; // 0-world center 1-screen center 2-target 3-=Width
	public var m_HeightIV:Number = 100.0;
	public var m_HeightID:Number = 0.0;
	public var m_HeightIG:Vector.<Number> = new Vector.<Number>();
	public var m_HeightRV:Number = 1.0;
	public var m_HeightRD:Number = 0.0;
	public var m_HeightRG:Vector.<Number> = new Vector.<Number>();
	public var m_HeightOV:Number = 1.0;
	public var m_HeightOD:Number = 0.0;
	public var m_HeightOG:Vector.<Number> = new Vector.<Number>();
	public var m_HeightAAdd:Number = 0.0;
	public var m_HeightAMul:Number = 1.0;
	public var m_HeightAPow:Number = 1.0;
	public var m_HeightBAdd:Number = 0.0;
	public var m_HeightBMul:Number = 1.0;
	public var m_HeightBPow:Number = 1.0;*/

	// Скорость частицы
	public var m_VelocityIV:Number = 100.0;
	public var m_VelocityID:Number = 0.0;
	public var m_VelocityIG:Vector.<Number> = new Vector.<Number>();
	public var m_VelocityRV:Number = 0.0;
	public var m_VelocityRD:Number = 0.0;
	public var m_VelocityRG:Vector.<Number> = new Vector.<Number>();
	public var m_VelocityOV:Number = 1.0;
	public var m_VelocityOD:Number = 0.0;
	public var m_VelocityOG:Vector.<Number> = new Vector.<Number>();
	public var m_VelocityAAdd:Number = 1.0;
	public var m_VelocityAMul:Number = 0.0;
	public var m_VelocityAPow:Number = 1.0;
	public var m_VelocityBAdd:Number = 1.0;
	public var m_VelocityBMul:Number = 0.0;
	public var m_VelocityBPow:Number = 1.0;

	// Вращение частицы
	public var m_SpinIV:Number = 0.0;
	public var m_SpinID:Number = 0.0;
	public var m_SpinIG:Vector.<Number> = new Vector.<Number>();
	public var m_SpinRV:Number = 0.0;
	public var m_SpinRD:Number = 0.0;
	public var m_SpinRG:Vector.<Number> = new Vector.<Number>();
	public var m_SpinOV:Number = 0.0;
	public var m_SpinOD:Number = 0.0;
	public var m_SpinOG:Vector.<Number> = new Vector.<Number>();
//	public var m_SpinAAdd:Number = 0.0;
//	public var m_SpinAMul:Number = 1.0;
//	public var m_SpinAPow:Number = 1.0;
//	public var m_SpinBAdd:Number = 0.0;
//	public var m_SpinBMul:Number = 1.0;
//	public var m_SpinBPow:Number = 1.0;

	// Цвет частицы
	public var m_ColorAdd:Boolean = false;
	public var m_ColorG:Vector.<uint> = new Vector.<uint>();

	public var m_AlphaIV:Number = 1.0;
	public var m_AlphaID:Number = 0.0;
	public var m_AlphaIG:Vector.<Number> = new Vector.<Number>();
	public var m_AlphaRV:Number = 0.0;
	public var m_AlphaRD:Number = 0.0;
	public var m_AlphaRG:Vector.<Number> = new Vector.<Number>();
	public var m_AlphaOV:Number = 0.0;
	public var m_AlphaOD:Number = 0.0;
	public var m_AlphaOG:Vector.<Number> = new Vector.<Number>();

/*	public var m_Color:uint = 0xffffffff;

	public var m_HueIV:Number = 0.0;
	public var m_HueID:Number = 0.0;
	public var m_HueIG:Vector.<Number> = new Vector.<Number>();
	public var m_HueRV:Number = 0.0;
	public var m_HueRD:Number = 0.0;
	public var m_HueRG:Vector.<Number> = new Vector.<Number>();
	public var m_HueOV:Number = 0.0;
	public var m_HueOD:Number = 0.0;
	public var m_HueOG:Vector.<Number> = new Vector.<Number>();
//	public var m_HueAAdd:Number = 0.0;
//	public var m_HueAMul:Number = 1.0;
//	public var m_HueAPow:Number = 1.0;
//	public var m_HueBAdd:Number = 0.0;
//	public var m_HueBMul:Number = 1.0;
//	public var m_HueBPow:Number = 1.0;

	public var m_SatIV:Number = 0.0;
	public var m_SatID:Number = 0.0;
	public var m_SatIG:Vector.<Number> = new Vector.<Number>();
	public var m_SatRV:Number = 0.0;
	public var m_SatRD:Number = 0.0;
	public var m_SatRG:Vector.<Number> = new Vector.<Number>();
	public var m_SatOV:Number = 0.0;
	public var m_SatOD:Number = 0.0;
	public var m_SatOG:Vector.<Number> = new Vector.<Number>();
//	public var m_SatAAdd:Number = 0.0;
//	public var m_SatAMul:Number = 1.0;
//	public var m_SatAPow:Number = 1.0;
//	public var m_SatBAdd:Number = 0.0;
//	public var m_SatBMul:Number = 1.0;
//	public var m_SatBPow:Number = 1.0;

	public var m_BriIV:Number = 0.0;
	public var m_BriID:Number = 0.0;
	public var m_BriIG:Vector.<Number> = new Vector.<Number>();
	public var m_BriRV:Number = 0.0;
	public var m_BriRD:Number = 0.0;
	public var m_BriRG:Vector.<Number> = new Vector.<Number>();
	public var m_BriOV:Number = 0.0;
	public var m_BriOD:Number = 0.0;
	public var m_BriOG:Vector.<Number> = new Vector.<Number>();
//	public var m_BriAAdd:Number = 0.0;
//	public var m_BriAMul:Number = 1.0;
//	public var m_BriAPow:Number = 1.0;
//	public var m_BriBAdd:Number = 0.0;
//	public var m_BriBMul:Number = 1.0;
//	public var m_BriBPow:Number = 1.0;*/

	public function EmitterStyle():void
	{
	}

	public function CopyVector(des:Vector.<Number>, src:Vector.<Number>):void
	{
		des.length = src.length;
		for (var i:int = 0; i < src.length; i++) des[i] = src[i];
	}

	public function CopyVectorColor(des:Vector.<uint>, src:Vector.<uint>):void
	{
		des.length = src.length;
		for (var i:int = 0; i < src.length; i++) des[i] = src[i];
	}

	public function CopyFrom(s:EmitterStyle):void
	{
		m_Img = s.m_Img;
		m_ImgCenterX = s.m_ImgCenterX;
		m_ImgCenterY = s.m_ImgCenterY;
		m_ImgScaleX = s.m_ImgScaleX;
		m_ImgScaleY = s.m_ImgScaleY;
		m_ImgRnd = s.m_ImgRnd;
		m_ImgAnim = s.m_ImgAnim;
		m_ImgSpeed = s.m_ImgSpeed;
		m_ImgDist = s.m_ImgDist;

		m_PosType = s.m_PosType;
		m_PosPath = s.m_PosPath;

		m_RadiusIV = s.m_RadiusIV; 
		m_RadiusID = s.m_RadiusID;
		CopyVector(m_RadiusIG, s.m_RadiusIG);
		m_RadiusRV = s.m_RadiusRV;
		m_RadiusRD = s.m_RadiusRD;
		CopyVector(m_RadiusRG, s.m_RadiusRG);
		m_RadiusAAdd = s.m_RadiusAAdd;
		m_RadiusAMul = s.m_RadiusAMul;
		m_RadiusAPow = s.m_RadiusAPow;
		m_RadiusBAdd = s.m_RadiusBAdd;
		m_RadiusBMul = s.m_RadiusBMul;
		m_RadiusBPow = s.m_RadiusBPow;

		m_AngleIV = s.m_AngleIV;
		m_AngleID = s.m_AngleID;
		CopyVector(m_AngleIG, s.m_AngleIG);
		m_AngleRV = s.m_AngleRV;
		m_AngleRD = s.m_AngleRD;
		CopyVector(m_AngleRG, s.m_AngleRG);

		m_RotateIV = s.m_RotateIV;
		m_RotateID = s.m_RotateID;
		CopyVector(m_RotateIG, s.m_RotateIG);
		m_RotateRV = s.m_RotateRV;
		m_RotateRD = s.m_RotateRD;
		CopyVector(m_RotateRG, s.m_RotateRG);

		m_OffsetIV = s.m_OffsetIV; 
		m_OffsetID = s.m_OffsetID;
		CopyVector(m_OffsetIG, s.m_OffsetIG);
		m_OffsetRV = s.m_OffsetRV;
		m_OffsetRD = s.m_OffsetRD;
		CopyVector(m_OffsetRG, s.m_OffsetRG);
		m_OffsetOV = s.m_OffsetOV;
		m_OffsetOD = s.m_OffsetOD;
		CopyVector(m_OffsetOG, s.m_OffsetOG);
		m_OffsetAAdd = s.m_OffsetAAdd;
		m_OffsetAMul = s.m_OffsetAMul;
		m_OffsetAPow = s.m_OffsetAPow;
		m_OffsetBAdd = s.m_OffsetBAdd;
		m_OffsetBMul = s.m_OffsetBMul;
		m_OffsetBPow = s.m_OffsetBPow;

		m_Period = s.m_Period;
		m_Loop = s.m_Loop;
		m_FirstFrame = s.m_FirstFrame;

		m_AmountIV = s.m_AmountIV;
		m_AmountID = s.m_AmountID;
		CopyVector(m_AmountIG, s.m_AmountIG);
		m_AmountRV = s.m_AmountRV;
		m_AmountRD = s.m_AmountRD;
		CopyVector(m_AmountRG, s.m_AmountRG);
		m_AmountAAdd = s.m_AmountAAdd;
		m_AmountAMul = s.m_AmountAMul;
		m_AmountAPow = s.m_AmountAPow;
		m_AmountBAdd = s.m_AmountBAdd;
		m_AmountBMul = s.m_AmountBMul;
		m_AmountBPow = s.m_AmountBPow;

		m_LifeIV = s.m_LifeIV;
		m_LifeID = s.m_LifeID;
		CopyVector(m_LifeIG, s.m_LifeIG);
		m_LifeRV = s.m_LifeRV;
		m_LifeRD = s.m_LifeRD;
		CopyVector(m_LifeRG, s.m_LifeRG);
		m_LifeAAdd = s.m_LifeAAdd;
		m_LifeAMul = s.m_LifeAMul;
		m_LifeAPow = s.m_LifeAPow;
		m_LifeBAdd = s.m_LifeBAdd;
		m_LifeBMul = s.m_LifeBMul;
		m_LifeBPow = s.m_LifeBPow;

		m_WidthType = s.m_WidthType;
		m_WidthIV = s.m_WidthIV;
		m_WidthID = s.m_WidthID;
		CopyVector(m_WidthIG, s.m_WidthIG);
		m_WidthRV = s.m_WidthRV;
		m_WidthRD = s.m_WidthRD;
		CopyVector(m_WidthRG, s.m_WidthRG);
		m_WidthOV = s.m_WidthOV;
		m_WidthOD = s.m_WidthOD;
		CopyVector(m_WidthOG, s.m_WidthOG);
		m_WidthAAdd = s.m_WidthAAdd;
		m_WidthAMul = s.m_WidthAMul;
		m_WidthAPow = s.m_WidthAPow;
		m_WidthBAdd = s.m_WidthBAdd;
		m_WidthBMul = s.m_WidthBMul;
		m_WidthBPow = s.m_WidthBPow;

		m_HeightType = s.m_HeightType;
	
		m_VelocityIV = s.m_VelocityIV;
		m_VelocityID = s.m_VelocityID;
		CopyVector(m_VelocityIG, s.m_VelocityIG);
		m_VelocityRV = s.m_VelocityRV;
		m_VelocityRD = s.m_VelocityRD;
		CopyVector(m_VelocityRG, s.m_VelocityRG);
		m_VelocityOV = s.m_VelocityOV;
		m_VelocityOD = s.m_VelocityOD;
		CopyVector(m_VelocityOG, s.m_VelocityOG);
		m_VelocityAAdd = s.m_VelocityAAdd;
		m_VelocityAMul = s.m_VelocityAMul;
		m_VelocityAPow = s.m_VelocityAPow;
		m_VelocityBAdd = s.m_VelocityBAdd;
		m_VelocityBMul = s.m_VelocityBMul;
		m_VelocityBPow = s.m_VelocityBPow;

		m_SpinIV = s.m_SpinIV;
		m_SpinID = s.m_SpinID;
		CopyVector(m_SpinIG, s.m_SpinIG);
		m_SpinRV = s.m_SpinRV;
		m_SpinRD = s.m_SpinRD;
		CopyVector(m_SpinRG, s.m_SpinRG);
		m_SpinOV = s.m_SpinOV;
		m_SpinOD = s.m_SpinOD;
		CopyVector(m_SpinOG, s.m_SpinOG);

		m_ColorAdd = s.m_ColorAdd;
		CopyVectorColor(m_ColorG, s.m_ColorG);

		m_AlphaIV = s.m_AlphaIV;
		m_AlphaID = s.m_AlphaID;
		CopyVector(m_AlphaIG, s.m_AlphaIG);
		m_AlphaRV = s.m_AlphaRV;
		m_AlphaRD = s.m_AlphaRD;
		CopyVector(m_AlphaRG, s.m_AlphaRG);
		m_AlphaOV = s.m_AlphaOV;
		m_AlphaOD = s.m_AlphaOD;
		CopyVector(m_AlphaOG, s.m_AlphaOG);

/*		m_Color = s.m_Color;

		m_HueIV = s.m_HueIV;
		m_HueID = s.m_HueID;
		CopyVector(m_HueIG, s.m_HueIG);
		m_HueRV = s.m_HueRV;
		m_HueRD = s.m_HueRD;
		CopyVector(m_HueRG, s.m_HueRG);
		m_HueOV = s.m_HueOV;
		m_HueOD = s.m_HueOD;
		CopyVector(m_HueOG, s.m_HueOG);

		m_SatIV = s.m_SatIV;
		m_SatID = s.m_SatID;
		CopyVector(m_SatIG, s.m_SatIG);
		m_SatRV = s.m_SatRV;
		m_SatRD = s.m_SatRD;
		CopyVector(m_SatRG, s.m_SatRG);
		m_SatOV = s.m_SatOV;
		m_SatOD = s.m_SatOD;
		CopyVector(m_SatOG, s.m_SatOG);

		m_BriIV = s.m_BriIV;
		m_BriID = s.m_BriID;
		CopyVector(m_BriIG, s.m_BriIG);
		m_BriRV = s.m_BriRV;
		m_BriRD = s.m_BriRD;
		CopyVector(m_BriRG, s.m_BriRG);
		m_BriOV = s.m_BriOV;
		m_BriOD = s.m_BriOD;
		CopyVector(m_BriOG, s.m_BriOG);*/
	}
}
	
}