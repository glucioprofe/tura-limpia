from sqlalchemy import Column, Integer, String, Float, Date, ForeignKey
from app.database.base import Base

class Mantenimiento(Base):
    __tablename__ = "mantenimientos"

    id_mantenimiento = Column(Integer, primary_key=True, index=True)
    id_vehiculo = Column(Integer, ForeignKey("vehiculos.id"), nullable=False)
    id_usuario = Column(Integer, ForeignKey("usuarios.id"), nullable=False)
    tipo_mantenimiento = Column(String(100), nullable=False)
    fecha_mantenimiento = Column(Date, nullable=False)
    descripcion = Column(String(500), nullable=False)
    kilometraje = Column(Integer, nullable=False)
    costo = Column(Float, nullable=False)
    taller_responsable = Column(String(150), nullable=False)
    proximo_mantenimiento = Column(Date, nullable=True)
    estado = Column(String(50), nullable=False)
    observaciones = Column(String(500), nullable=True)