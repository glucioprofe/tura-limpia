from sqlalchemy import Column, Integer, String, Enum
from app.database.base import Base

class Usuario(Base):
    __tablename__ = "usuarios"

    id = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100), nullable=False)
    correo = Column(String(100), unique=True, index=True, nullable=False)
    contrasena = Column(String(200), nullable=False)
    
    # Aquí está la columna con los roles actualizados
    rol = Column(
        Enum("Cliente/Ciudadano", "Trabajador", "Conductor", "Gerente", "Administrador", name="rol_usuario_enum"), 
        nullable=False
    )