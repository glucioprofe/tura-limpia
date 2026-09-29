from fastapi import FastAPI
from app.database.connection import engine

app = FastAPI(title="Tura Limpia API")

@app.get("/")
def read_root():
    return {"success": True, "message": "API funcionando", "data": {}}

@app.get("/test-db")
def test_db():
    try:
        with engine.connect() as conn:
            return {"success": True, "message": "Conexion exitosa", "data": {}}
    except Exception as e:
        return {"success": False, "message": "Error de conexion", "error": str(e)}