#!/usr/bin/env/ bats

@test "No Parameters Passed Test" {
        run ../use_cases/check_password_requirements/check_password_requirements.sh
        [ "$status" -eq 1 ]
        [[ "$output" == *"parameter is required"* ]]
}


@test "8 Character Minimum Test #1" {
        run ../use_cases/check_password_requirements/check_password_requirements.sh 8476
        [ "$status" -eq 1 ]
        [[ "$output" == *"8 characters"* ]]
}

@test "8 Character Minimum Test #2" {
        run ../use_cases/check_password_requirements/check_password_requirements.sh 8476
        [ "$status" -eq 1 ]
        [[ "$output" == *"8 characters"* ]]
}

@test "1 Uppercase Letter Test #1" {
        run ../use_cases/check_password_requirements/check_password_requirements.sh 123456789
        [ "$status" -eq 1 ]
        [[ "$output" == *"uppercase"* ]]
}

@test "1 Uppercase Letter Test #2" {
        run ../use_cases/check_password_requirements/check_password_requirements.sh abc32917
        [ "$status" -eq 1 ]
        [[ "$output" == *"uppercase"* ]]
}

@test "1 Digit Minimum Test #1" {
        run ../use_cases/check_password_requirements/check_password_requirements.sh Abcdefgh
        [ "$status" -eq 1 ]
        [[ "$output" == *"digit"* ]]
}

@test "1 Digit Minimum Test #2" {
        run ../use_cases/check_password_requirements/check_password_requirements.sh PassWord!
        [ "$status" -eq 1 ]
        [[ "$output" == *"digit"* ]]
}



@test "All Requirements Passed Test #1" {
        run ../use_cases/check_password_requirements/check_password_requirements.sh 12345678A
        # checks if the script runs correctly
        [ "$status" -eq 0 ]
        [[ "$output" == *"strong"* ]]
}

@test "All Requirements Passed Test #2" {
        run ../use_cases/check_password_requirements/check_password_requirements.sh PassW0rd!
        # checks if the script runs correctly
        [ "$status" -eq 0 ]
        [[ "$output" == *"strong"* ]]
}


