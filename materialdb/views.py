from django.shortcuts import render, redirect
from django.views.generic import TemplateView, ListView
from django.template import RequestContext
from .models import *
from materialdb.forms import AddIntersection


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
        print(route_list)
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
    template_name = 'addperson.html'

    def get(self, request):
        form = AddIntersection()
        return render(request, self.template_name, {'form':form})

    def post(self, request):
        form = AddIntersection(request.POST or None)

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

            Passenger.objects.create_user(passenger_id=id, ssn=ssn, job=job, sex=sex, email=email, dob=dob)
            return redirect('/route/table')

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