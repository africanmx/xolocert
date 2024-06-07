from fastapi import FastAPI, HTTPException, Request
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import os
import subprocess

app = FastAPI()
bearer_scheme = HTTPBearer()

BEARER_TOKEN = os.getenv("BEARER_TOKEN")

@app.middleware("http")
async def verify_bearer_token(request: Request, call_next):
    if "authorization" not in request.headers:
        raise HTTPException(status_code=401, detail="Authorization header missing")
    
    credentials: HTTPAuthorizationCredentials = await bearer_scheme(request)
    if credentials.credentials != BEARER_TOKEN:
        raise HTTPException(status_code=401, detail="Invalid token")
    
    response = await call_next(request)
    return response

@app.post("/generate_certificate")
async def generate_certificate():
    try:
        result = subprocess.run(["xolocert", "--create"], capture_output=True, text=True, check=True)
        return {"message": "Certificate generated", "output": result.stdout}
    except subprocess.CalledProcessError as e:
        raise HTTPException(status_code=500, detail=f"Certificate generation failed: {e.stderr}")

@app.get("/verify_certificate")
async def verify_certificate():
    try:
        result = subprocess.run(["xolocert", "--verify"], capture_output=True, text=True, check=True)
        return {"message": "Certificate verified", "output": result.stdout}
    except subprocess.CalledProcessError as e:
        raise HTTPException(status_code=500, detail=f"Certificate verification failed: {e.stderr}")
