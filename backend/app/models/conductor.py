from sqlalchemy import Column, Integer, String, Date
from app.database.base import Base

class Conductor(Base):
    __tablename__ = "conductores"

    id_conductor = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100), nullable=False)
    cedula = Column(String(20), unique=True, nullable=False)
    telefono = Column(String(20), nullable=True)
    numero_licencia = Column(String(50), unique=True, nullable=False)
    categoria_licencia = Column(String(10), nullable=False)
    fecha_vencimiento_licencia = Column(Date, nullable=False)
    estado = Column(String(50), nullable=False)
    fecha_ingreso = Column(Date, nullable=False)
    observaciones = Column(String(500), nullable=True)