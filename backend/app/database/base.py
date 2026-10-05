from sqlalchemy.orm import declarative_base

Base = declarative_base()

from app.models.usuario import Usuario
from app.models.vehiculo import Vehiculo
from app.models.ruta import Ruta
from app.models.conductor import Conductor
from app.models.mantenimiento import Mantenimiento
from app.models.asignacion_ruta import AsignacionRuta
from app.models.incidencia import Incidencia