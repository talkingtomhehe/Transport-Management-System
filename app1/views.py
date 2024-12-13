from django.shortcuts import render, redirect
from django.http import HttpResponse
from .models import *
from datetime import date
from django.db import connection

cursor = connection.cursor()
def register(request):
    if request.method == 'POST':
        uname = request.POST.get('name')
        uemail = request.POST.get('email')
        upass = request.POST.get('password')
        ucpass = request.POST.get('cpassword')
        utype = request.POST.get('user_type')
        checkExist = Users.objects.filter(name=uname,email=uemail,password=upass).count()
        if checkExist > 0:
            context = {'message' : 'The user already exists!'}
            return render(request, 'register.html', context)
        elif upass != ucpass:
            context = {'message' : 'The password does not match!'}
            return render(request, 'register.html', context)
        else:
            newUser = Users(name=uname,email=uemail,password=upass,user_type=utype)
            newUser.save()
            return redirect(login)
    return render(request, 'register.html', {})
def login(request):
    if request.method == 'POST':
        uname = request.POST.get('name')
        uemail = request.POST.get('email')
        upass = request.POST.get('password')
        personLogin = Users.objects.filter(name=uname,email=uemail,password=upass)
        checkExist = personLogin.count()
        if checkExist > 0:
            validPerson = personLogin.values()
            if validPerson.count() > 1:
                context = {'message': 'Something wrong happened'}
                return render(request, 'login.html',context)
            else:
               if validPerson[0]['user_type'] == 'user':
                   request.session['user_name'] = uname
                   request.session['user_email'] = uemail
                   request.session['user_id'] = validPerson[0]['id']
                   request.session['loginType'] = validPerson[0]['user_type']
                   return redirect(login)
               else:
                   request.session['admin_name'] = uname
                   request.session['admin_email'] = uemail
                   request.session['admin_id'] = validPerson[0]['id']
                   request.session['loginType'] = validPerson[0]['user_type']
                   return redirect(adminPanel)
        else:
            context = {'message': 'Invalid account!'}
            return render(request, 'login.html',context)
    return render(request, 'login.html', {})
def logout(request):
    try:
        if request.session['loginType'] == 'user':
            del request.session['user_name']
            del request.session['user_email']
            del request.session['user_id']
            del request.session['loginType']
        else:
            del request.session['admin_name']
            del request.session['admin_email']
            del request.session['admin_id']
            del request.session['loginType']
    except:
        return redirect(login)
    return redirect(login)
def adminPanel(request):
    if 'admin_name' in request.session:
        current_user_name = request.session['admin_name']
        current_user_email = request.session['admin_email']
        many_person  = Person.objects.all()
        many_users = Users.objects.all()
        many_comp = Company.objects.all()
        many_public = PublicVehicle.objects.all()
        many_private = PrivateVehicle.objects.all()
        many_cust = Customer.objects.all()
        many_cargo = Cargo.objects.all()
        many_route = Route.objects.all()
        many_station = StationStop.objects.all()
        many_park = Park.objects.all()
        many_sell = Sell.objects.all()
        context = {'current_user':[current_user_name, current_user_email],
                   'many_person':many_person, 
                   'many_comp': many_comp,
                   'many_users': many_users,
                   'many_public': many_public,
                   'many_private': many_private,
                   'many_cust': many_cust,
                   'many_cargo': many_cargo,
                   'many_route': many_route,
                   'many_station': many_station,
                   'many_park': many_park,
                   'many_sell': many_sell
                   }
        return render(request, 'admin-page.html', context)
    else:
        return redirect(login)

def adminProduct(request):
    if request.method == 'POST':
        brand = request.POST.get("brand")
        vehAge = request.POST.get("vehAge")
        owner = request.POST.get("owner")
        typeV = request.POST.get("typeV")
        plate = request.POST.get("plate_number")
        vehType = request.POST.get("vehicle_type")
        latestIdNum = request.POST.get("regID")
        max_capacity = request.POST.get("max_capacity")
        model = request.POST.get("model")
        current_user_name = request.session['admin_name']
        current_user_email = request.session['admin_email']
        many_public = PublicVehicle.objects.all()
        many_private = PrivateVehicle.objects.all()
        if PublicVehicle.objects.filter(license_plate_no=plate).exists() or PrivateVehicle.objects.filter(plate_number=plate).exists():
            content = {
                "message": "Duplicate license plate number",
                'many_public': many_public,
                'many_private': many_private,
                'current_user': [current_user_name, current_user_email]
            }
            return render(request, "admin-product.html", content)
        if owner[0:3] != 'OWN' or latestIdNum[0:3] != 'VEH':
            content = {"message": "Invalid input",
                       'many_public': many_public,
                   'many_private': many_private,
                   'current_user':[current_user_name, current_user_email]
                   }
            return render(request, "admin-product.html",content)
        else:
            if Vehicle.objects.filter(reg_id = latestIdNum).count() > 0 or PrivateVehicle.objects.filter(reg_id = latestIdNum).count() > 0 or PublicVehicle.objects.filter(reg_id = latestIdNum).count() > 0:
                content = {"message": "Duplicate register ID",
                       'many_public': many_public,
                   'many_private': many_private,
                   'current_user':[current_user_name, current_user_email]
                   }
                return render(request, "admin-product.html",content)
            if typeV == 'private':
                try:
                    cursor.execute('call insert_owner_private_vehicle_info(%s,%s,%s,%s,%s)', (owner, latestIdNum, brand, plate, vehType))
                finally:
                    cursor.close()
            else:
                if vehType != 'bus' and vehType != 'train' and vehType != 'Bus' and vehType != 'Train':
                    content = {"message": "Invalid type of vehicle",
                       'many_public': many_public,
                   'many_private': many_private,
                   'current_user':[current_user_name, current_user_email]
                   }
                    return render(request, "admin-product.html",content)
                checkO = OwnerInfo.objects.filter(owner_id = owner).count()
                if checkO == 0:
                    content = {
                        "message": "Owner does not exist. Please register owner contact first.",
                        'many_public': many_public,
                        'many_private': many_private,
                        'current_user': [current_user_name, current_user_email]
                    }
                    return render(request, "admin-product.html", content)
                newVehicle = Vehicle(reg_id = latestIdNum, brand=brand, vehicle_age= vehAge, owner_id = owner)
                newVehicle.save()
                newPublic = PublicVehicle(reg_id = latestIdNum, maximum_capacity = max_capacity,vehicle_type = vehType, model = model,license_plate_no = plate)
                newPublic.save()
            content = {"message": "Vehicle added successully!",
                       'many_public': many_public,
                   'many_private': many_private,
                   'current_user':[current_user_name, current_user_email]
                   }
            return render(request, "admin-product.html", content)
        
    if 'admin_name' in request.session:
        current_user_name = request.session['admin_name']
        current_user_email = request.session['admin_email']
        many_public = PublicVehicle.objects.all()
        many_private = PrivateVehicle.objects.all()
        context = {'current_user':[current_user_name, current_user_email],
                   'many_public': many_public,
                   'many_private': many_private
                   }
        return render(request, 'admin-product.html', context)
    else:
        return redirect(login)
    
def updatePro(request,proId,action, typeV):
    if request.method == 'POST':
        brand = request.POST.get("brand")
        vehAge = request.POST.get("vehAge")
        owner = request.POST.get("owner")
        plate = request.POST.get("plate_number")
        vehType = request.POST.get("vehicle_type")
        max_capacity = request.POST.get("max_capacity")
        model = request.POST.get("model")
        if typeV == 'public':
            myVeh = PublicVehicle.objects.get(reg_id = proId)
            if vehType != 'bus' and vehType != 'train' and vehType != 'Bus' and vehType != 'Train':
                return redirect(adminProduct)
            myVeh.vehicle_type = vehType
            myVeh.maximum_capacity = max_capacity
            myVeh.model = model
            myVeh.save()
        else:
            myVeh = PrivateVehicle.objects.get(reg_id = proId)
            myVeh.plate_number = plate
            myVeh.vehicle_type = vehType
            myVeh.save()
        checkO = OwnerInfo.objects.filter(owner_id = owner).count()
        if checkO == 0:
            return redirect(adminProduct)
        myVehcile = Vehicle.objects.get(reg_id = proId)
        myVehcile.brand = brand
        myVehcile.vehicle_age = vehAge
        myVehcile.owner.owner_id=owner
        myVehcile.save()
        return redirect(adminProduct)
    if 'admin_name' in request.session:
        current_user_name = request.session['admin_name']
        current_user_email = request.session['admin_email']
        if typeV == 'public':
            many_products = PublicVehicle.objects.all()
        else:
            many_products = PrivateVehicle.objects.all()
        proUpd = many_products.get(reg_id=proId)
        context = {'current_user':[current_user_name, current_user_email],
                   'many_products': many_products,
                   'proUpd': proUpd
                   }
        return render(request, 'admin-product.html', context)
    else:
        return redirect(login)

def deletePro(request,prodId,action, typeV): 
    if typeV == 'public':
        myVehicle = PublicVehicle.objects.get(reg_id = prodId)
        myVehicle.delete()
    else:
        myVehicle = PrivateVehicle.objects.get(reg_id = prodId)
        myVehicle.delete()
    generalVehicle = Vehicle.objects.get(reg_id = prodId)
    generalVehicle.delete()
    return redirect(adminProduct)

def adminOrders(request):
    if 'admin_name' in request.session:
        current_user_name = request.session['admin_name']
        current_user_email = request.session['admin_email']
        many_orders = TrafficViolation.objects.all()
        context = {'current_user':[current_user_name, current_user_email],
                   'many_orders': many_orders
                   }
        return render(request, 'admin-orders.html', context)
    else:
        return redirect(login)
def deleteOrder(request, ordId, violation_time):
    deadOrder = TrafficViolation.objects.get(owner_id = ordId, violation_time = violation_time)
    deadOrder.delete()
    return redirect(adminOrders)
def adminUsers(request):
    if 'admin_name' in request.session:
        current_user_name = request.session['admin_name']
        current_user_email = request.session['admin_email']
        many_users = Users.objects.all()
        context = {'current_user':[current_user_name, current_user_email],
                   'many_users': many_users
                   }
        return render(request, 'admin-users.html', context)
    else:
        return redirect(login)
    
def deleteUser(request,uId):
    deadUser = Users.objects.get(id=uId)
    deadUser.delete()
    return redirect(adminUsers)
def adminContacts(request):
    if 'admin_name' in request.session:
        current_user_name = request.session['admin_name']
        current_user_email = request.session['admin_email']
        many_messages =PhoneNumber.objects.all()
        context = {'current_user':[current_user_name, current_user_email],
                   'many_messages': many_messages
                   }
        return render(request, 'admin-contacts.html', context)
    else:
        return redirect(login)   
def deleteContact(request, messId):
    try:
        # Delete the PhoneNumber record
        deadMess = PhoneNumber.objects.get(owner_id=messId)
        deadMess.delete()

        # Delete the Person record
        owner = OwnerInfo.objects.get(owner_id=messId)
        if Person.objects.filter(owner=owner).exists():
            person = Person.objects.get(owner=owner)
            person.delete()

        # Delete the OwnerInfo record
        owner.delete()

    except OwnerInfo.DoesNotExist:
        # Handle the case where the owner does not exist
        pass

    return redirect(adminContacts)

def addTrafficViolation(request):
    if request.method == 'POST':
        owner_id = request.POST.get("owner")
        violation_time = request.POST.get("violation_time")
        violation_name = request.POST.get("violation_name")
        violation_address = request.POST.get("violation_address")
        violation_description = request.POST.get("violation_description")
        current_user_name = request.session['admin_name']
        current_user_email = request.session['admin_email']
        many_orders = TrafficViolation.objects.all()

        # Check if the owner exists
        if not OwnerInfo.objects.filter(owner_id=owner_id).exists():
            content = {
                "message": "Owner does not exist",
                'many_orders': many_orders,
                'current_user': [current_user_name, current_user_email]
            }
            return render(request, "admin-orders.html", content)

        # Check for duplicate violation at the same time
        owner = OwnerInfo.objects.get(owner_id=owner_id)
        if TrafficViolation.objects.filter(owner=owner, violation_time=violation_time).exists():
            content = {
                "message": "Duplicate violation entry",
                'many_orders': many_orders,
                'current_user': [current_user_name, current_user_email]
            }
            return render(request, "admin-orders.html", content)

        # Save the new traffic violation
        new_violation = TrafficViolation(
            owner_id=owner_id,
            violation_time=violation_time,
            violation_name=violation_name,
            violation_address=violation_address,
            violation_description=violation_description
        )
        new_violation.save()

        content = {
            "message": "Traffic violation added successfully!",
            'many_orders': many_orders,
            'current_user': [current_user_name, current_user_email]
        }
        return render(request, "admin-orders.html", content)

    if 'admin_name' in request.session:
        current_user_name = request.session['admin_name']
        current_user_email = request.session['admin_email']
        many_orders = TrafficViolation.objects.all()
        context = {
            'current_user': [current_user_name, current_user_email],
            'many_orders': many_orders
        }
        return render(request, 'admin-orders.html', context)
    else:
        return redirect(login)
    
def addContact(request):
    if request.method == 'POST':
        owner_id = request.POST.get("owner")
        name = request.POST.get("name")
        ssn = request.POST.get("ssn")
        driving_license = request.POST.get("driving_license")
        dob = request.POST.get("dob")
        phone_number = request.POST.get("phone_number")
        isp = request.POST.get("isp")
        region = request.POST.get("region")
        current_user_name = request.session['admin_name']
        current_user_email = request.session['admin_email']
        many_messages = PhoneNumber.objects.all()

        # Check if the owner exists
        if not OwnerInfo.objects.filter(owner_id=owner_id).exists():
            # Create new owner
            new_owner = OwnerInfo(owner_id=owner_id, dob=dob)
            new_owner.save()
            # Create new person
            new_person = Person(owner=new_owner, pname=name, ssn=ssn, driving_license=driving_license)
            new_person.save()
        else:
            # Update existing owner and person
            owner = OwnerInfo.objects.get(owner_id=owner_id)
            owner.dob = dob
            owner.save()
            if not Person.objects.filter(owner=owner).exists():
                new_person = Person(owner=owner, pname=name, ssn=ssn, driving_license=driving_license)
                new_person.save()
            else:
                person = Person.objects.get(owner=owner)
                person.pname = name
                person.ssn = ssn
                person.driving_license = driving_license
                person.save()

        # Check for duplicate phone number
        if PhoneNumber.objects.filter(phone_number=phone_number).exists():
            content = {
                "message": "Duplicate phone number entry",
                'many_messages': many_messages,
                'current_user': [current_user_name, current_user_email]
            }
            return render(request, "admin-contacts.html", content)

        # Save the new contact
        owner = OwnerInfo.objects.get(owner_id=owner_id)
        new_contact = PhoneNumber(
            owner=owner,
            phone_number=phone_number,
            isp=isp,
            region=region
        )
        new_contact.save()

        content = {
            "message": "Contact added successfully!",
            'many_messages': many_messages,
            'current_user': [current_user_name, current_user_email]
        }
        return render(request, "admin-contacts.html", content)

    if 'admin_name' in request.session:
        current_user_name = request.session['admin_name']
        current_user_email = request.session['admin_email']
        many_messages = PhoneNumber.objects.all()
        context = {
            'current_user': [current_user_name, current_user_email],
            'many_messages': many_messages
        }
        return render(request, 'admin-contacts.html', context)
    else:
        return redirect(login)
    
