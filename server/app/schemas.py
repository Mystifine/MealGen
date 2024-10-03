from marshmallow import Schema, fields, validate, validates, validates_schema, ValidationError;
import re;

class UserSchema(Schema):
    _id = fields.Str(dump_only=True)  # Ensure _id is only included when serializing, not during input validation
    email = fields.Email(required=True);
    username = fields.Str(required=True, validate=validate.Length(min=1));
    password = fields.Str(required=True, validate=validate.Length(min=8));
    stars = fields.Int(strict=True);
      
    @validates("username")
    def validate_username(self, value):
      # usernames can only contain letters numbers and underscore
      pattern = r'^[A-Za-z0-9_]+$'
    
      # Use re.match to check if the string matches the pattern
      if not bool(re.match(pattern, value)):
        raise ValidationError("Username should only contain letters and numbers and _.");
        
    @validates("password")
    def validate_password(self, value):
      if len(value) < 8:
        raise ValidationError("Password must contain 8 characters");

class UserLoginSchema(UserSchema):
    email = fields.Email(required=False);
    username = fields.Str(required=False);
    
    @validates_schema
    def validate_login(self, data, **kwargs):
        # ensure that either 'username' or 'email' is provided, but not both
        if not data.get('username') and not data.get('email'):
            raise ValidationError("Either username or email must be provided.")

    class Meta:
      exclude = ("stars",)

class UserSignUpSchema(UserSchema):
    class Meta:
        exclude = ("stars",)

class UserClientSchema(UserSchema):

    class Meta:
        # exclude the 'password' field for login
        exclude = ("password",)