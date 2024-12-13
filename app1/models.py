from django.db import models
from django.db.models import *

# Create your models here.
class Belongs(models.Model):
    ssi_passport = models.OneToOneField('Passenger', models.DO_NOTHING, db_column='ssi_passport', primary_key=True)  # The composite primary key (ssi_passport, get_on_time, reg_id, belong_name) found, that is not supported. The first column is selected.
    get_on_time = models.ForeignKey('Passenger', models.DO_NOTHING, db_column='get_on_time', to_field='get_on_time', related_name='belongs_get_on_time_set')
    reg = models.ForeignKey('Passenger', models.DO_NOTHING, to_field='reg_id', related_name='belongs_reg_set')
    belong_name = models.CharField(max_length=32)
    weight = models.FloatField(blank=True, null=True)
    numbers = models.IntegerField(blank=True, null=True)
    dim = models.CharField(max_length=32, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'belongs'
        unique_together = (('ssi_passport', 'get_on_time', 'reg', 'belong_name'),)


class BusOrder(models.Model):
    station_name = models.OneToOneField('StationStop', models.DO_NOTHING, db_column='station_name', primary_key=True)  # The composite primary key (station_name, bus_order) found, that is not supported. The first column is selected.
    bus_order = models.CharField(max_length=32)

    class Meta:
        managed = True
        db_table = 'bus_order'
        unique_together = (('station_name', 'bus_order'),)


class Cargo(models.Model):
    cargo_id = models.CharField(primary_key=True, max_length=32)
    cargo_date = models.DateField(blank=True, null=True)
    note = models.CharField(max_length=32, blank=True, null=True)
    weight = models.CharField(max_length=32, blank=True, null=True)
    receiver = models.CharField(max_length=32, blank=True, null=True)
    sender = models.CharField(max_length=32, blank=True, null=True)
    dim = models.CharField(max_length=32, blank=True, null=True)
    receiver_ssn = models.CharField(max_length=32, blank=True, null=True)
    sender_ssn = models.CharField(max_length=32, blank=True, null=True)
    from_locations = models.CharField(max_length=32, blank=True, null=True)
    receiver_name = models.CharField(max_length=32, blank=True, null=True)
    sender_name = models.CharField(max_length=32, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'cargo'


class Company(models.Model):
    owner = models.OneToOneField('OwnerInfo', models.DO_NOTHING, primary_key=True)
    cname = models.CharField(db_column='Cname', max_length=32, blank=True, null=True)  # Field name made lowercase.
    cid = models.CharField(db_column='Cid', max_length=32, blank=True, null=True)  # Field name made lowercase.

    class Meta:
        managed = True
        db_table = 'company'


class Customer(models.Model):
    ssi_passport = models.CharField(primary_key=True, max_length=32)
    gender = models.CharField(max_length=32, blank=True, null=True)
    age = models.IntegerField(blank=True, null=True)
    customer_name = models.CharField(max_length=32, blank=True, null=True)
    nationality = models.CharField(max_length=32, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'customer'


class CustomerHealthIssue(models.Model):
    ssi_passport = models.OneToOneField(Customer, models.DO_NOTHING, db_column='ssi_passport', primary_key=True)  # The composite primary key (ssi_passport, health_issue) found, that is not supported. The first column is selected.
    health_issue = models.CharField(max_length=32)

    class Meta:
        managed = True
        db_table = 'customer_health_issue'
        unique_together = (('ssi_passport', 'health_issue'),)


class Deliver(models.Model):
    reg = models.ForeignKey('PublicVehicle', models.DO_NOTHING, to_field='reg_id', blank=True, null=True)
    station_name = models.ForeignKey('StationStop', models.DO_NOTHING, db_column='station_name', blank=True, null=True)
    cargo = models.OneToOneField(Cargo, models.DO_NOTHING, primary_key=True)

    class Meta:
        managed = True
        db_table = 'deliver'


class DisabledLanguage(models.Model):
    id = models.IntegerField(primary_key=True)
    reg_id = models.CharField(max_length=32, blank=True, null=True)
    park_id = models.CharField(max_length=32)
    address = models.CharField(max_length=32, blank=True, null=True)
    from_time = models.TimeField(blank=True, null=True)
    to_time = models.TimeField(blank=True, null=True)
    parking_day = models.DateField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'disabled_language'

class DrivingEmployee(models.Model):
    ssi = models.CharField(primary_key=True, max_length=32)
    working_date = models.DateField(blank=True, null=True)
    working_hours = models.CharField(max_length=32, blank=True, null=True)
    age = models.IntegerField(blank=True, null=True)
    driver_type = models.CharField(max_length=32, blank=True, null=True)
    driving_certifications = models.CharField(max_length=32, blank=True, null=True)
    license_plate_no = models.ForeignKey('PublicVehicle', models.DO_NOTHING, db_column='license_plate_no', blank=True, null=True)
    driving_certification = models.CharField(max_length=32, blank=True, null=True)
    date_taken = models.DateField(blank=True, null=True)
    date_expired = models.DateField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'driving_employee'


class GoPass(models.Model):
    route = models.OneToOneField('Route', models.DO_NOTHING, primary_key=True)  # The composite primary key (route_id, station_name) found, that is not supported. The first column is selected.
    station_name = models.ForeignKey('StationStop', models.DO_NOTHING, db_column='station_name')
    departure_time = models.TimeField(blank=True, null=True)
    arrival_time = models.TimeField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'go_pass'
        unique_together = (('route', 'station_name'),)


class Insurance(models.Model):
    insurance_number = models.IntegerField(primary_key=True)
    company_name = models.CharField(max_length=32, blank=True, null=True)
    insurance_value = models.IntegerField(blank=True, null=True)
    insurance_type = models.CharField(max_length=32, blank=True, null=True)
    reg = models.ForeignKey('Vehicle', models.DO_NOTHING, blank=True, null=True)
    started_date = models.DateField(blank=True, null=True)
    expired_date = models.DateField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'insurance'


class OwnerInfo(models.Model):
    owner_id = models.CharField(primary_key=True, max_length=32)
    dob = models.DateField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'owner_info'


class Parent(models.Model):
    parent_ssi_passport = models.OneToOneField(Customer, models.DO_NOTHING, db_column='parent_ssi_passport', primary_key=True)  # The composite primary key (parent_ssi_passport, child_ssi_passport) found, that is not supported. The first column is selected.
    child_ssi_passport = models.ForeignKey(Customer, models.DO_NOTHING, db_column='child_ssi_passport', related_name='parent_child_ssi_passport_set')

    class Meta:
        managed = True
        db_table = 'parent'
        unique_together = (('parent_ssi_passport', 'child_ssi_passport'),)


class Park(models.Model):
    reg = models.OneToOneField('PrivateVehicle', models.DO_NOTHING, primary_key=True)  # The composite primary key (reg_id, address) found, that is not supported. The first column is selected.
    address = models.CharField(max_length=32, unique=True)

    class Meta:
        managed = True
        db_table = 'park'
        unique_together = (('reg', 'address'),)
    @property
    def count_address(self):
        return Park.objects.values('address').distinct().count()


class ParkingTime(models.Model):
    id = models.IntegerField()
    reg = models.ForeignKey(Park, models.DO_NOTHING, blank=True, null=True)
    park_id = models.CharField(primary_key=True, max_length=32)
    address = models.ForeignKey(Park, models.DO_NOTHING, db_column='address', to_field='address', related_name='parkingtime_address_set', blank=True, null=True)
    from_time = models.TimeField(blank=True, null=True)
    to_time = models.TimeField(blank=True, null=True)
    parking_day = models.DateField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'parking_time'


class Passenger(models.Model):
    ssi_passport = models.OneToOneField(Customer, models.DO_NOTHING, db_column='ssi_passport', primary_key=True)  # The composite primary key (ssi_passport, get_on_time, reg_id) found, that is not supported. The first column is selected.
    get_on_time = models.DateTimeField(unique=True)
    reg = models.ForeignKey('PublicVehicle', models.DO_NOTHING, to_field='reg_id', unique=True)
    depart_location = models.CharField(max_length=32, blank=True, null=True)
    destination = models.CharField(max_length=32, blank=True, null=True)
    get_off_time = models.DateTimeField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'passenger'
        unique_together = (('ssi_passport', 'get_on_time', 'reg'),)


class Person(models.Model):
    pname = models.CharField(db_column='Pname', max_length=32, blank=True, null=True)  # Field name made lowercase.
    ssn = models.CharField(max_length=32, blank=True, null=True)
    driving_license = models.CharField(max_length=32, blank=True, null=True)
    owner = models.OneToOneField(OwnerInfo, models.DO_NOTHING, primary_key=True)

    class Meta:
        managed = True
        db_table = 'person'


class PhoneNumber(models.Model):
    owner = models.OneToOneField(OwnerInfo, models.DO_NOTHING, primary_key=True)  # The composite primary key (owner_id, phone_number) found, that is not supported. The first column is selected.
    phone_number = models.CharField(unique=True, max_length=32)
    isp = models.CharField(max_length=32, blank=True, null=True)
    region = models.CharField(max_length=32, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'phone_number'
        unique_together = (('owner', 'phone_number'),)


class PrivateVehicle(models.Model):
    reg = models.OneToOneField('Vehicle', models.DO_NOTHING, primary_key=True)
    plate_number = models.CharField(max_length=32, blank=True, null=True)
    vehicle_type = models.CharField(max_length=32, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'private_vehicle'


class PublicVehicle(models.Model):
    reg = models.OneToOneField('Vehicle', models.DO_NOTHING)
    maximum_capacity = models.IntegerField(blank=True, null=True)
    vehicle_type = models.CharField(max_length=32, blank=True, null=True)
    model = models.CharField(max_length=32, blank=True, null=True)
    license_plate_no = models.CharField(primary_key=True, max_length=32)

    class Meta:
        managed = True
        db_table = 'public_vehicle'


class RegularParking(models.Model):
    address = models.CharField(primary_key=True, max_length=32)
    parking_type = models.CharField(max_length=32, blank=True, null=True)
    capacity = models.CharField(max_length=32, blank=True, null=True)
    no_of_vehicle = models.IntegerField(unique=True)

    class Meta:
        managed = True
        db_table = 'regular_parking'


class Route(models.Model):
    route_id = models.CharField(primary_key=True, max_length=32)  # The composite primary key (route_id, reg_id) found, that is not supported. The first column is selected.
    reg = models.ForeignKey(PublicVehicle, models.DO_NOTHING, to_field='reg_id')

    class Meta:
        managed = True
        db_table = 'route'
        unique_together = (('route_id', 'reg'),)


class Sell(models.Model):
    buyer = models.OneToOneField(OwnerInfo, models.DO_NOTHING, primary_key=True)  # The composite primary key (buyer_id, seller_id) found, that is not supported. The first column is selected.
    reg = models.ForeignKey('Vehicle', models.DO_NOTHING, blank=True, null=True)
    seller = models.ForeignKey(OwnerInfo, models.DO_NOTHING, related_name='sell_seller_set')

    class Meta:
        managed = True
        db_table = 'sell'
        unique_together = (('buyer', 'seller'),)
    @property
    def count_buyer(self):
        return Sell.objects.values('buyer').distinct().count()
    @property
    def count_seller(self):
        return Sell.objects.values('seller').distinct().count()


class StationStop(models.Model):
    station_name = models.CharField(primary_key=True, max_length=32)
    address = models.CharField(max_length=32, blank=True, null=True)
    capacity = models.CharField(max_length=32, blank=True, null=True)
    purpose = models.CharField(max_length=32, blank=True, null=True)
    number_of_vehicle = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'station_stop'


class TrafficViolation(models.Model):
    owner = models.OneToOneField(OwnerInfo, on_delete=models.CASCADE)  # The composite primary key (owner_id, violation_time) found, that is not supported. The first column is selected.
    violation_time = models.DateTimeField(primary_key=True)
    violation_name = models.CharField(max_length=32, blank=True, null=True)
    violation_address = models.CharField(max_length=32, blank=True, null=True)
    violation_description = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'traffic_violation'
        unique_together = (('owner', 'violation_time'),)


class TriggerControl(models.Model):
    triggername = models.CharField(db_column='TriggerName', primary_key=True, max_length=500)  # Field name made lowercase.
    conditions = models.IntegerField(blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'trigger_control'


class Users(models.Model):
    name = models.CharField(max_length=100, blank=True, null=True)
    email = models.CharField(max_length=100, blank=True, null=True)
    password = models.CharField(max_length=100, blank=True, null=True)
    user_type = models.CharField(max_length=20, blank=True, null=True)

    class Meta:
        managed = True
        db_table = 'users'


class Vehicle(models.Model):
    reg_id = models.CharField(primary_key=True, max_length=32)  # The composite primary key (reg_id, owner_id) found, that is not supported. The first column is selected.
    brand = models.CharField(max_length=32, blank=True, null=True)
    vehicle_age = models.IntegerField(blank=True, null=True)
    owner = models.ForeignKey(OwnerInfo, models.DO_NOTHING)

    class Meta:
        managed = True
        db_table = 'vehicle'
        unique_together = (('reg_id', 'owner'),)


class VehicleDamageHistory(models.Model):
    damage_history = models.CharField(max_length=255)
    reg = models.OneToOneField(Vehicle, models.DO_NOTHING, primary_key=True)  # The composite primary key (reg_id, damage_history) found, that is not supported. The first column is selected.

    class Meta:
        managed = True
        db_table = 'vehicle_damage_history'
        unique_together = (('reg', 'damage_history'),)