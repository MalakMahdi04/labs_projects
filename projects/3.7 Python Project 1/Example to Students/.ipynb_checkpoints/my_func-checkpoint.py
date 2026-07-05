import csv
import uuid
from datetime import date, datetime, timedelta

def add_habit():
    """Adding a new habit into the habits csv file"""

    # try to open the file. If the file does not exist, create one
    try:
        with open('habits.csv', 'r', newline='') as file:
            reader = csv.DictReader(file)
            for row in reader:
                row['target_goal'] = int(row['target_goal'])
                row['active'] = row['active'].lower() == 'true'
        print('\nhabits.csv exist.')
    except :
        with open('habits.csv', 'w', newline='') as file:
            writer = csv.writer(file)
            writer.writerow(['id', 'name', 'frequency', 'target_goal', 'category', 'start_date', 'active'])
            print('\n\nnew habits.csv created')

    print("\n=== Add a New Habit ===")
    habit_id = str(uuid.uuid4())[:8] # To create unique id everytime a habit is added 
    name = input("Enter habit name: ")

    # Validate frequency
    valid_frequencies = ['daily', 'weekly', 'monthly']
    print("\nFrequency options: Daily, Weekly, Monthly")
    while True:
        print("Please enter a valid frequency: Daily, Weekly, or Monthly.")
        frequency = input("Enter habit frequency: ").lower()
        if frequency in valid_frequencies:
            break
        

    # Validate target goal
    while True:
        try:
            target_goal = int(input("Enter target goal (e.g., number of repetitions): "))
            if target_goal > 0:
                break
            print("Please enter a positive number.")
        except ValueError:
            print("Please enter a valid number.")

    # Get category
    print("\nCategory examples: Health, Productivity, Learning, Fitness, Finance")
    category = input("Enter habit category: ")

    # Validate start date
    while True:
        start_date = input("Enter start date (YYYY-MM-DD) or press Enter for today: ")
        if not start_date.strip():  # Use today's date
            start_date = date.today().strftime("%Y-%m-%d")
            break
        try:
            datetime.strptime(start_date, "%Y-%m-%d")
            break
        except ValueError:
            print("Invalid date format. Please use YYYY-MM-DD.")

    # Create new habit
    new_habit = {
        'id': habit_id,
        'name': name,
        'frequency': frequency,
        'target_goal': target_goal,
        'category': category,
        'start_date': start_date,
        'active': True
    }
    try:
        with open('habits.csv', 'a', newline='') as file:
            fn = ['id', 'name', 'frequency', 'target_goal', 'category', 'start_date', 'active']
            writer = csv.DictWriter(file, fieldnames=fn)
            writer.writerow(new_habit)
            print(f"\nHabit '{name}' added successfully!")
            print(f"Start tracking this habit from {start_date}")
    except Exception as e:
        print(f'Error saving new habit:{e}')
    
    

def display_menu():
    """Display the main menu options."""
    print("\n=== Habit Tracker ===")
    print("1. Add a new habit to track")
    print("2. Log completion of a habit")
    print("3. View habit streaks and statistics")
    print("4. Edit or remove habits")
    print("5. View all habits")
    print("6. Visualize habits (calendar view)")
    print("7. View rewards")
    print("8. Exit")
    return input("Enter your choice (1-8): ")

def main():
    """Main application function."""
    print("Welcome to Habit Tracker!")
    print("This app helps you build and maintain positive habits.")

    while True:
        choice = display_menu()

        if choice == '1':
            add_habit()
        elif choice == '2':
            log_habit_completion()
        elif choice == '3':
            view_streaks_and_statistics()
        elif choice == '4':
            edit_or_remove_habits()
        elif choice == '5':
            view_all_habits()
        elif choice == '6':
            visualize_habits()
        elif choice == '7':
            reward_system()
        elif choice == '8':
            print("Thank you for using Habit Tracker. Goodbye!")
            break
        else:
            print("Invalid choice. Please enter a number between 1 and 8.")


