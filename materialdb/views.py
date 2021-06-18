from django import forms
from django.http.request import HttpRequest
from django.shortcuts import render, redirect
from django.urls.conf import path
from django.views.generic import TemplateView, ListView
from django.template import RequestContext
from .models import *
from materialdb.forms import AddRoute, AddTrip, AddVisit


class DashboardView(ListView):
    template_name = 'dashboard.html'

    def get_queryset(self):
        return Passenger.objects.all()

class UserTableView(ListView):
    template_name = './user/table.html'

    def get_queryset(self):
        return Passenger.objects.all()

    def post(self, request):
        form = Passenger(request.POST or None)

        context = { 'form': form }

        if 'deleteEntry' in request.POST:
            id_num = request.POST['deleteEntry']
            Passenger.objects.filter(passenger_id=id_num).delete()

            return redirect('/user/tableview')

        elif 'editEntry' in request.POST:

            values = request.POST['editEntry']
            values = values.split(',')
            request.session['id'] = values[0]
            request.session['ssn'] = values[1]
            request.session['job'] = values[2]
            request.session['sex'] = values[3]
            request.session['email'] = values[4]
            request.session['dob'] = values[5]


            return redirect('route/edit')

class RouteTableView(ListView):
    template_name = './route/table.html'
            
    def get_queryset(self):
        trip_list = list(Trip.objects.all().values())
        route_list = list(Route.objects.all().values())
        # stopping_point_list = list(Stopping_point.objects.all().values())
        # visit_list = list(Visit.objects.all().values())
        # distance_list = list(Distance.objects.all().values())

        context = list(map(lambda route: {'route_id': route['route_id'], 'trip_index': []}, route_list))
        for trip in trip_list:
            for c in context:
                if trip['route_id'] == c['route_id']:
                    c['trip_index'].append(trip['trip_index'])
        return context

    def post(self, request):
        form = (request.POST or None)

        context = { 'form': form }

        if 'editTripEntry' in request.POST:
            values = request.POST['editTripEntry']
            values = values.split(',')
            request.session['route_id'] = str(values[1]).strip()
            request.session['trip'] = str(values[0]).strip()
            return redirect('/route/edittrip', 
                    EditTripView.as_view(), 
                    {})

        elif 'editEntry' in request.POST:
            values = request.POST['editEntry']
            values = values.split(',')
            request.session['route_id'] = values[0]
            request.session['trip'] = values[1]
            return redirect('/route/addtrip', AddTripView.as_view(), {'route_id': values[0], 'trip': values[1]})

class AddRouteView(TemplateView):
    template_name = './route/addroute.html'

    def get(self, request):
        form = AddRoute()
        trip = AddTrip()
        return render(request, self.template_name, {'form':form, 'trip_form': trip})

    def post(self, request):
        form = AddRoute(request.POST or None)
        context = { 'form': form }
        if form.is_valid():
            route_id = form.cleaned_data['route_id_type'] + form.cleaned_data['route_id_num']
            context.update({'route_id': route_id})

            # Create route
            Route(route_id).save()

            if form.cleaned_data['route_id_type'] == 'T':
                train_name = form.cleaned_data['train_name']
                train_unit_price = form.cleaned_data['train_unit_price']
                train_route_id = form.cleaned_data['train_route_id']
                Train_route(route_id=route_id, train_route_id=train_route_id, train_name=train_name, train_unit_price=train_unit_price).save()
            else:
                bus_id = 1 + max([bus['bus_route_id'] for bus in list(Bus_route.objects.all().values())])
                Bus_route(route_id=route_id, bus_route_id=bus_id).save()
            return redirect('/route/tableview')

        return render(request, self.template_name, context)

class AddTripView(TemplateView):
    template_name = './route/addtrip.html'

    def get(self, request):
        trip = AddTrip()
        trip.route_id=request.session['route_id']
        return render(request, self.template_name, {'form':trip, 
                    'route_id': request.session['route_id'], 
                    'trip': request.session['trip']
                    })

    def post(self, request):
        form = AddTrip(request.POST or None)
        context = { 'form': form }
        if form.is_valid():
            trip_index = form.cleaned_data['trip_index']
            context.update({'trip_index': trip_index})

            route_id = form.cleaned_data['route_id']
            context.update({'route_id': route_id})
            
            Trip.objects.create(route_id=route_id, trip_index=trip_index)
            return redirect('/route/tableview')
        return render(request, self.template_name, context)
    
class EditTripView(TemplateView):
    template_name = './route/edittrip.html'

    def get(self, request):
        trip_id = request.session['trip']
        route_id = request.session['route_id']
        visit_list = list(Visit.objects.all().values())
        visit_list = [visit for visit in visit_list if visit['trip_route_id'] == str(route_id) and str(visit['trip_index']) == str(trip_id)]
        visit_list = sorted(visit_list, key=lambda x: x['visit_index'])
        
        for visit in visit_list:
            visit['departure_time'] = str(visit['departure_time']).upper()
            visit['arrival_time'] = str(visit['arrival_time']).upper()

        form = AddVisit()
        return render(request, self.template_name, {'visit_list' : visit_list,
                        'route_id': route_id,
                        'trip_index': trip_id,
                        'form': form})

    def post(self, request):
        form = AddTrip(request.POST or None)
        context = { 'form': form }
        if form.is_valid():
            trip_index = form.cleaned_data['trip_index']
            context.update({'trip_index': trip_index})

            route_id = form.cleaned_data['route_id']
            context.update({'route_id': route_id})
            
            Trip.objects.create(route_id=route_id, trip_index=trip_index)
            return redirect('/route/tableview')
        return render(request, self.template_name, context)


