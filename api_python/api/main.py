from fastapi import FastAPI

app = FastAPI()

@app.get("/api/users")
async def root():
    return [
        {
            "id": 1,
            "name": "joel doel",
            "email": "joeldoel@email.com"
        }
    ]