# Astronomy

**Story:**

As a user, I want to see the Astronomy Picture of the Day, so that I can learn new things about our Universe everyday.


**Story Description:**

NASA releases the Astronomy Picture of the Day everyday. This is accompanied by the title of the picture and a short explanation of about it.
We want to build a iOS/Android App where the user can see the daily picture.
Consider this page as a small part of a large App and structure it accordingly. Use the architecture of your choice that would work best for such an App.
API source: https://api.nasa.gov API key required: Yes Endpoint: https://api.nasa.gov/planetary/apod UX: Use your judgement on best practices, be conscious of the time limit and, keep the UI simple. There are no extra points for very fancy UI.


**Acceptance Criteria**

1. Given: The NASA APOD API is up (working) AND the phone is connected to the internet When: The user arrives at the APOD page for the first time today Then: The page should display the image of Astronomy Picture of the Day along with the title and explanation, for that day
2. Given: The user has already seen the APOD page once AND the phone is not connected to the internet When: The user arrives at the APOD page on the same day Then: The page should display the image of Astronomy Picture of the Day along with the title and explanation, for that day
3. Given: The user has not seen the APOD page today AND the phone is not connected to the internet When: The user arrives at the APOD page Then: The page should display an error "We are not connected to the internet, showing you the last image we have." AND The page should display the image of Astronomy Picture of the Day along with the title and explanation, that was last seen by the user
4. Given: The NASA APOD API is up (working) AND the phone is connected to the internet When: The APOD image loads fully on the screen Then: The user should be able to see the complete image without distortion or clipping
