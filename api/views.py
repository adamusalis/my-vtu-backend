from django.http import JsonResponse
from django.contrib.auth.models import User
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.hashers import make_password
import json
  
def health(request):
        return JsonResponse({"status": "ok", "app": "vtu-backend"})  
@csrf_exempt
def register(request):
    if request.method != "POST":
        return JsonResponse({"error": "POST only"}, status=400)
    try:
        body = json.loads(request.body)
        username = body.get("username")
        password = body.get("password")
    except:
        return JsonResponse({"error": "Invalid JSON"}, status=400)
  
    if not username or not password:
        return JsonResponse({"error": "username and password required"}, status=400)
  
    if User.objects.filter(username=username).exists():
        return JsonResponse({"error": "user exists"}, status=400)
  
        User.objects.create(username=username, password=make_password(password))
        return JsonResponse({"message": "User created"}, status=201)
  
def me(request):
    # simple unauthenticated placeholder — replace with JWT-protected logic later
    if not request.user or not request.user.is_authenticated:
        return JsonResponse({"detail": "Authentication credentials were not provided."}, status=401)
    user = request.user
    return JsonResponse({
            "id": user.id, 
            "username": user.username,
             "email": user.email
})

