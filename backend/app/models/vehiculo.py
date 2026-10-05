from sqlalchemy import Column, Integer, String, Date
from app.database.base import Base

class Vehiculo(Base):
    __tablename__ = "vehiculos"

    id = Column(Integer, primary_key=True, index=True)
    marca = Column(String(50), nullable=False)
    modelo = Column(String(50), nullable=False)
    tipo_vehiculo = Column(String(50), nullable=False)
    fecha_vencimiento_soad = Column(Date, nullable=True)
    fecha_vencimiento_seguro = Column(Date, nullable=True)
    fecha_vencimiento_tecnomecanica = Column(Date, nullable=True)
    kilometraje = Column(Integer, nullable=False, default=0)
    ultimo_mantenimiento = Column(Date, nullable=True)
    observaciones = Column(String(500), nullable=True)