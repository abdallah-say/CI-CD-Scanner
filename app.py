from flask import Flask

app = Flask (__name__)

@app.route('/')
def home():
    return "Secured Cloud Application Infrastructure - Monitoring Active."

if __name__ == '__main__':
    # Binds to 0.0.0.0 to allow traffic into the container
    app.run(host='0.0.0.0', port=8080)