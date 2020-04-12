import json
from flask import request, jsonify, Blueprint, abort
from flask.views import MethodView
from my_app import db, app
from my_app.catalog.models import Meal
 
catalog = Blueprint('catalog', __name__)
 
@catalog.route('/')
@catalog.route('/home')
def home():
    return "Welcome to the Catalog Home."
 
 
class ProductView(MethodView):
 
    def get(self, id=None, page=1):
        if not id:
            products = Meal.query
            res = []
            for product in products:
                res.append({'foodName': product.foodName,
                'calories': product.calories,
                'imageURL': product.imageURL,
                'type': product.type,
                'ingredients': product.ingredients,
                'steps': product.steps
                })

        else:
            product = Meal.query.filter_by(id=id).first()
            if not product:
                abort(404)
            res = {
                'foodName': product.foodName,
                'calories': product.calories,
                'imageURL': product.imageURL,
                'type': product.type,
                'ingredients': product.ingredients,
                'steps': product.steps,
            }
        # arr = json.dumps(res)
        return jsonify(res)
 
    def post(self):
        # parsed_data = json.dumps(request.json)
        # print(parsed_data)
        foodName = request.args.get("foodName")
        calories = request.args.get('calories')
        imageURL = request.args.get('imageURL')
        type = request.args.get('type')
        ingredients = request.args.get('ingredients')
        steps = request.args.get('steps')
        product = Meal(foodName, calories, imageURL, type, ingredients, steps)
        db.session.add(product)
        db.session.commit()
        return jsonify({product.id: {
            'foodName': product.foodName,
            'calories': product.calories,
            'imageURL': product.imageURL,
            'type': product.type,
            'ingredients': product.ingredients,
            'steps': product.steps,
        }})
 
    def put(self, id):
        # Update the record for the provided id
        # with the details provided.
        return
 
    def delete(self, id):
        # Delete the record for the provided id.
        return
 
 
product_view =  ProductView.as_view('product_view')
app.add_url_rule(
    '/meal/', view_func=product_view, methods=['GET', 'POST']
)
app.add_url_rule(
    '/meal/<int:id>', view_func=product_view, methods=['GET']
)