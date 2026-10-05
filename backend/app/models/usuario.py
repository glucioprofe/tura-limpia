from sqlalchemy import Column, Integer, String
from app.database.base import Base

class Usuario(Base):
    __tablename__ = "usuarios"

    id = Column(Integer, primary_key=True, index=True)
    rol = Column(String(50), nullable=False)
    nombre = Column(String(100), nullable=False)
    correo = Column(String(100), unique=True, index=True, nullable=False)
    telefono = Column(String(20), nullable=True)
    cedula = Column(String(20), unique=True, nullable=False)
    direccion = Column(String(200), nullable=True)