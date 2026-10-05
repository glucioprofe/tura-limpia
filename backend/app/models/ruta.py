from sqlalchemy import Column, Integer, String, Float, Time
from app.database.base import Base

class Ruta(Base):
    __tablename__ = "rutas"

    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100), nullable=False)
    descripcion = Column(String(255), nullable=True)
    zona_sector = Column(String(100), nullable=False)
    hora_inicio = Column(Time, nullable=False)
    hora_fin = Column(Time, nullable=False)
    distancia_estimada = Column(Float, nullable=True)
    estado = Column(String(50), nullable=False)