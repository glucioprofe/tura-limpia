from sqlalchemy import Column, Integer, String, Date, Time, ForeignKey
from app.database.base import Base

class Incidencia(Base):
    __tablename__ = "incidencias"

    id_incidencia = Column(Integer, primary_key=True, index=True)
    id_asignacion = Column(Integer, ForeignKey("asignacion_rutas.id_asignacion"), nullable=False)
    id_usuario = Column(Integer, ForeignKey("usuarios.id"), nullable=False)
    tipo_incidencia = Column(String(100), nullable=False)
    descripcion = Column(String(500), nullable=False)
    fecha = Column(Date, nullable=False)
    hora = Column(Time, nullable=False)
    estado = Column(String(50), nullable=False)
    observaciones = Column(String(500), nullable=True)