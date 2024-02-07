from manage import app
from waitress import serve


serve(app, listen='0.0.0.0:31415', threads=4)
