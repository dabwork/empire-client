package Engine
{
import flash.geom.*;
	
public class C3DHelper
{
	public static const TypeSphere:int = 1;
	public static const TypeCone:int = 2;
	public static const TypeCylinder:int = 3;
	public static const TypeArrow:int = 4;
	
	public var m_Id:*= undefined;

	public var m_Type:int = 0;
	public var m_Radius:Number = 0;
	public var m_Radius2:Number = 0;
	public var m_Clr:uint = 0;
	public var m_Clr2:uint = 0;
	
	public var m_X:Number = 0;
	public var m_Y:Number = 0;
	public var m_Z:Number = 0;
	public var m_NX:Number = 0;
	public var m_NY:Number = 0;
	public var m_NZ:Number = 0;
	
	public var m_D:Number = 0;
	public var m_Len:Number = 0;
	
	public var m_Angle:Number = 0;
	public var m_Angle2:Number = 0;
	
	private static var m_MeshSphere:C3DMesh = null;
	private static var m_MeshCone:C3DMesh = null;
	private static var m_MeshCylinder:C3DMesh = null;
	
	private static var m_MatrixTmp:Matrix3D = new Matrix3D();
	
	public function Sphere(x:Number, y:Number, z:Number, r:Number, clr:uint):void
	{
		m_Type = TypeSphere;
		m_Radius = r;
		m_Radius2 = r;
		m_Clr = clr;
		
		m_X = x;
		m_Y = y;
		m_Z = z;
	}
	
	public function Cone(fromx:Number, fromy:Number, fromz:Number, tox:Number, toy:Number, toz:Number, r:Number, clr:uint):void
	{
		m_Type = TypeCone;
		m_Radius = r;
		m_Radius2 = r;
		m_Clr = clr;

		m_X = fromx;
		m_Y = fromy;
		m_Z = fromz;

		m_NX = tox - fromx;
		m_NY = toy - fromy;
		m_NZ = toz - fromz;

		m_D = Math.sqrt(m_NX * m_NX + m_NY * m_NY + m_NZ * m_NZ);
		if (m_D <= 0.0001) { m_D = 0.0; m_NX = 1.0; m_NY = 0.0; m_NZ = 0.0; }
		else {
			var k:Number = 1.0 / m_D;
			m_NX *= k; m_NY *= k; m_NZ *= k;

			if (m_NX > 0) m_Angle2 = Math.atan(m_NY / m_NX);
			else if (m_NX < 0) m_Angle2 = Math.PI + Math.atan(m_NY / m_NX);
			else if ((m_NX = 0) && (m_NY >= 0)) m_Angle2 = 3.0 * Math.PI / 2.0;
			else m_Angle2 = Math.PI / 2.0;

			m_Angle = Math.acos(m_NZ);
		}
	}

	public function Cylinder(fromx:Number, fromy:Number, fromz:Number, tox:Number, toy:Number, toz:Number, r:Number, clr:uint):void
	{
		m_Type = TypeCylinder;
		m_Radius = r;
		m_Radius2 = r;
		m_Clr = clr;

		m_X = fromx;
		m_Y = fromy;
		m_Z = fromz;

		m_NX = tox - fromx;
		m_NY = toy - fromy;
		m_NZ = toz - fromz;

		m_D = Math.sqrt(m_NX * m_NX + m_NY * m_NY + m_NZ * m_NZ);
		if (m_D <= 0.0001) { m_D = 0.0; m_NX = 1.0; m_NY = 0.0; m_NZ = 0.0; }
		else {
			var k:Number = 1.0 / m_D;
			m_NX *= k; m_NY *= k; m_NZ *= k;

			if (m_NX > 0) m_Angle2 = Math.atan(m_NY / m_NX);
			else if (m_NX < 0) m_Angle2 = Math.PI + Math.atan(m_NY / m_NX);
			else if ((m_NX = 0) && (m_NY >= 0)) m_Angle2 = 3.0 * Math.PI / 2.0;
			else m_Angle2 = Math.PI / 2.0;

			m_Angle = Math.acos(m_NZ);
		}
	}

	public function Arrow(fromx:Number, fromy:Number, fromz:Number, tox:Number, toy:Number, toz:Number, r:Number, r2:Number, len:Number, clr:uint):void
	{
		m_Type = TypeArrow;
		m_Radius = r;
		m_Radius2 = r2;
		m_Clr = clr;

		m_X = fromx;
		m_Y = fromy;
		m_Z = fromz;

		m_NX = tox - fromx;
		m_NY = toy - fromy;
		m_NZ = toz - fromz;

		m_D = Math.sqrt(m_NX * m_NX + m_NY * m_NY + m_NZ * m_NZ);
		if (m_D <= 0.0001) { m_D = 0.0; m_NX = 1.0; m_NY = 0.0; m_NZ = 0.0; }
		else {
			var k:Number = 1.0 / m_D;
			m_NX *= k; m_NY *= k; m_NZ *= k;

			if (m_NX > 0) m_Angle2 = Math.atan(m_NY / m_NX);
			else if (m_NX < 0) m_Angle2 = Math.PI + Math.atan(m_NY / m_NX);
			else if ((m_NX = 0) && (m_NY >= 0)) m_Angle2 = 3.0 * Math.PI / 2.0;
			else m_Angle2 = Math.PI / 2.0;

			m_Angle = Math.acos(m_NZ);
		}
		
		m_Len = len;
		if (m_Len > m_D * 0.9) m_Len = m_D * 0.9;
	}

	public static function Draw(ar:Array, m:Matrix3D):void
	{
		if (ar.length <= 0) return;
		C3D.ShaderHelper();

		var h:C3DHelper;
		for each (h in ar) {
			if (h.m_Type == TypeSphere) {
				if (m_MeshSphere == null) m_MeshSphere = new C3DMesh();
				if (!m_MeshSphere.IsInitGraph()) m_MeshSphere.CreateSphere(1.0, 10);

				m_MatrixTmp.identity();
				m_MatrixTmp.appendScale(h.m_Radius, h.m_Radius, h.m_Radius);
				m_MatrixTmp.appendTranslation(h.m_X, h.m_Y, h.m_Z);
				m_MatrixTmp.append(m);

				C3D.SetVConstMatrix(0, m_MatrixTmp);
				C3D.SetFConst_Color(0, h.m_Clr);

				C3D.VBMesh(m_MeshSphere, false, false);
				C3D.DrawMesh();

			} else if (h.m_Type == TypeCone) {
				if (m_MeshCone == null) m_MeshCone = new C3DMesh();
				if (!m_MeshCone.IsInitGraph()) m_MeshCone.CreateCone(0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 10, true, false);

				m_MatrixTmp.identity();
				m_MatrixTmp.appendScale(h.m_Radius, h.m_Radius, h.m_D);
				m_MatrixTmp.appendRotation(h.m_Angle * 180.0 / Math.PI, Vector3D.Y_AXIS);
				m_MatrixTmp.appendRotation(h.m_Angle2 * 180.0 / Math.PI, Vector3D.Z_AXIS);
				m_MatrixTmp.appendTranslation(h.m_X, h.m_Y, h.m_Z);
				m_MatrixTmp.append(m);

				C3D.SetVConstMatrix(0, m_MatrixTmp);
				C3D.SetFConst_Color(0, h.m_Clr);

				C3D.VBMesh(m_MeshCone, false, false);
				C3D.DrawMesh();

			} else if (h.m_Type == TypeCylinder) {
				if (m_MeshCylinder == null) m_MeshCylinder = new C3DMesh();
				if (!m_MeshCylinder.IsInitGraph()) m_MeshCylinder.CreateCone(0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 10, true, true);

				m_MatrixTmp.identity();
				m_MatrixTmp.appendScale(h.m_Radius, h.m_Radius, h.m_D);
				m_MatrixTmp.appendRotation(h.m_Angle * 180.0 / Math.PI, Vector3D.Y_AXIS);
				m_MatrixTmp.appendRotation(h.m_Angle2 * 180.0 / Math.PI, Vector3D.Z_AXIS);
				m_MatrixTmp.appendTranslation(h.m_X, h.m_Y, h.m_Z);
				m_MatrixTmp.append(m);

				C3D.SetVConstMatrix(0, m_MatrixTmp);
				C3D.SetFConst_Color(0, h.m_Clr);

				C3D.VBMesh(m_MeshCylinder, false, false);
				C3D.DrawMesh();

			} else if (h.m_Type == TypeArrow) {
				if (m_MeshCone == null) m_MeshCone = new C3DMesh();
				if (!m_MeshCone.IsInitGraph()) m_MeshCone.CreateCone(0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 10, true, false);
				if (m_MeshCylinder == null) m_MeshCylinder = new C3DMesh();
				if (!m_MeshCylinder.IsInitGraph()) m_MeshCylinder.CreateCone(0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 10, true, true);

				// Cylinder
				m_MatrixTmp.identity();
				m_MatrixTmp.appendScale(h.m_Radius, h.m_Radius, h.m_D - h.m_Len);
				m_MatrixTmp.appendRotation(h.m_Angle * 180.0 / Math.PI, Vector3D.Y_AXIS);
				m_MatrixTmp.appendRotation(h.m_Angle2 * 180.0 / Math.PI, Vector3D.Z_AXIS);
				m_MatrixTmp.appendTranslation(h.m_X, h.m_Y, h.m_Z);
				m_MatrixTmp.append(m);

				C3D.SetVConstMatrix(0, m_MatrixTmp);
				C3D.SetFConst_Color(0, h.m_Clr);

				C3D.VBMesh(m_MeshCylinder, false, false);
				C3D.DrawMesh();
				
				// Cone
				m_MatrixTmp.identity();
				m_MatrixTmp.appendScale(h.m_Radius2, h.m_Radius2, h.m_Len);
				m_MatrixTmp.appendRotation(h.m_Angle * 180.0 / Math.PI, Vector3D.Y_AXIS);
				m_MatrixTmp.appendRotation(h.m_Angle2 * 180.0 / Math.PI, Vector3D.Z_AXIS);
				m_MatrixTmp.appendTranslation(h.m_X + h.m_NX * (h.m_D - h.m_Len), h.m_Y + h.m_NY * (h.m_D - h.m_Len), h.m_Z + h.m_NZ * (h.m_D - h.m_Len));
				m_MatrixTmp.append(m);

				C3D.SetVConstMatrix(0, m_MatrixTmp);
				C3D.SetFConst_Color(0, h.m_Clr);

				C3D.VBMesh(m_MeshCone, false, false);
				C3D.DrawMesh();
			}
		}
	}
}
	
}