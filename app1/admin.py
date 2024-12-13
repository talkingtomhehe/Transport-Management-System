from django.contrib import admin
from .models import *

admin.site.register(Users)
admin.site.register(PublicVehicle)
admin.site.register(PrivateVehicle)
admin.site.register(Person)
admin.site.register(Company)
admin.site.register(Customer)
admin.site.register(Cargo)
admin.site.register(Route)
admin.site.register(StationStop)
admin.site.register(Park)
admin.site.register(Sell)