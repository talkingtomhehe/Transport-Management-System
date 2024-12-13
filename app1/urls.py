from django.contrib import admin
from django.urls import path
from . import views

urlpatterns = [
    path('', views.login, name="login"),
    path('register/', views.register, name="register"),
    path('adminPanel/',views.adminPanel, name="adminPanel"),
    path('logout/', views.logout, name="logout"),
    path('vehicle/',views.adminProduct,name="adminProduct"),
    path('vehicle/<str:proId>/<str:action>/<str:typeV>/',views.updatePro,name="updatePro"),
    path('vehicles/<str:action>/<str:prodId>/<str:typeV>/',views.deletePro,name="deletePro"),
    path('violation/',views.adminOrders,name="adminOrders"),
    path('violations/<str:ordId>/<str:violation_time>/',views.deleteOrder,name="deleteOrder"),
    path('adminUsers/',views.adminUsers,name="adminUsers"),
    path('adminUsers/<int:uId>/',views.deleteUser,name="deleteUser"),
    path('phoneOwner/',views.adminContacts,name="adminContacts"),
    path('phoneOwners/<str:messId>/',views.deleteContact,name="deleteContact"),
    path('add_traffic_violation/', views.addTrafficViolation, name="add_traffic_violation"),
    path('add_contact/', views.addContact, name="add_contact"),
]   