from my_app import db

class Meal(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    foodName = db.Column(db.String(255))
    calories = db.Column(db.Integer)
    imageURL = db.Column(db.String(255))
    type = db.Column(db.String(255))
    ingredients = db.Column(db.String(255))
    steps = db.Column(db.String(255))

 
    def __init__(self, foodName, calories, imageURL, type, ingredients, steps):
        self.foodName = foodName
        self.calories = calories
        self.imageURL = imageURL
        self.type = type
        self.ingredients = ingredients
        self.steps = steps
 
    def __repr__(self):
        return ('<Meal %d>' , self.id)