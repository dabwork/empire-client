// Copyright (C) 2013 Elemental Games. All rights reserved.

package QE
{

public class  QEText
{
	static public const TypeEnd:int = 0; // Конец строки
	static public const TypeText:int = 1; // простой текст
	static public const TypeSub:int = 2; // простая подстановка
	static public const TypePage:int = 3; // подстовляемый текст из другой странички
	static public const TypeCode:int = 4; // код подстановки
	static public const TypeRun:int = 5; // код на выполнение
	static public const TypeIf:int = 6; // условие
	static public const TypeIfEnd:int = 7; // конец условия
	static public const TypeElse:int = 8; // другой вариант условия.
	static public const TypeElseIf:int = 9; // другой вариант условия.
	
	public var m_Type:int = 0;
	public var m_Data:Object = null;
	
	public function QEText():void
	{
	}
}
	
}