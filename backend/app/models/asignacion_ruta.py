from sqlalchemy import Column, Integer, String, Date, Time, ForeignKey
from app.database.base import Base

class AsignacionRuta(Base):
    __tablename__ = "asignacion_rutas"

    id_asignacion = Column(Integer, primary_key=True, index=True)
    id_ruta = Column(Integer, ForeignKey("rutas.id"), nullable=False)
    id_conductor = Column(Integer, ForeignKey("conductores.id_conductor"), nullable=False)
    id_vehiculo = Column(Integer, ForeignKey("vehiculos.id"), nullable=False)
    id_usuario = Column(Integer, ForeignKey("usuarios.id"), nullable=False)
    fecha = Column(Date, nullable=False)
    hora_inicio = Column(Time, nullable=False)
    hora_fin = Column(Time, nullable=False)
    estado = Column(String(50), nullable=False)