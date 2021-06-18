from django.shortcuts import render, redirect
from django.views.generic import TemplateView, ListView
from django.template import RequestContext
from .models import *
from materialdb.forms import AddRoute, AddTrip


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
        stopping_point_list = list(Stopping_point.objects.all().values())
        visit_list = list(Visit.objects.all().values())
        distance_list = list(Distance.objects.all().values())

        context = list(map(lambda route: {'route_id': route['route_id'], 'trip_index': []}, route_list))
        for trip in trip_list:
            for c in context:
                if trip['route_id'] == c['route_id']:
                    c['trip_index'].append(trip['trip_index'])
        return context

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

class EditIntersectionView(TemplateView):
    template_name = './route/edit.html'

    def get(self, request):
        passenger = Passenger()
        return render(request, self.template_name, {'form':[passenger]})

    def post(self, request):
        form = Passenger(request.POST or None)
        context = { 'form': form }
        if form.is_valid():

            id = form.cleaned_data['id']
            context.update({'id': id})

            ssn = form.cleaned_data['ssn']
            context.update({'ssn': ssn})

            job = form.cleaned_data['job']
            context.update({'job': job})

            sex = form.cleaned_data['sex']
            context.update({'sex': sex})

            email = form.cleaned_data['email']
            context.update({'email': email})

            dob = form.cleaned_data['dob']
            context.update({'dob': dob})

            passenger= Passenger.objects.create_user(passenger_id=id, ssn=ssn, job=job, sex=sex, email=email, dob=dob)

            return redirect('/route/tableview')
        return render(request, self.template_name, context)