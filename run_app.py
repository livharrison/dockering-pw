from manage import app
from waitress import serve


serve(app, listen='127.0.0.1:31415', threads=4)
