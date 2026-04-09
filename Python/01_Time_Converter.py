def convert_minutes(minutes):
    hours = minutes // 60
    mins = minutes % 60

    if hours == 0:
        return f"{mins} minutes"
    elif hours == 1:
        return f"{hours} hour {mins} minutes"
    else:
        return f"{hours} hours {mins} minutes"
print(convert_minutes(130)) 
print(convert_minutes(110)) 
print(convert_minutes(45))    
