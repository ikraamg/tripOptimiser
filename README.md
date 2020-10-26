<!-- [![Contributors][contributors-shield]][contributors-url][![Forks][forks-shield]][forks-url][![Stargazers][stars-shield]][stars-url][![Issues][issues-shield]][issues-url] -->
[![hire-badge](https://img.shields.io/badge/Consult%20/%20Hire%20Ikraam-Click%20to%20Contact-brightgreen)](mailto:consult.ikraam@gmail.com) [![Twitter Follow](https://img.shields.io/twitter/follow/GhoorIkraam?label=Follow%20Ikraam%20on%20Twitter&style=social)](https://twitter.com/GhoorIkraam)

# Trip Optimiser
<!-- PROJECT LOGO -->

<br />
<p align="center">
  <a href="https://github.com/ikraamg/etaPath.git">
    <p align="center"> <img src="https://user-images.githubusercontent.com/34813339/97208673-13507180-17c4-11eb-918e-7360436c48bd.png" alt="etaPath" height="500">
    </p>
  </a>

  <h3 align="center">Trip Optimiser - Fleet and passenger efficiency algorithm </h3>

  <p align="center">
    <a href="https://github.com/ikraamg/etaPath/issues">Report a Bug or Request a Feature</a>
    ·
    <a href="https://tech-favourites.herokuapp.com/home">Live Demo</a>
  </p>
</p>

<!-- Live Link  -->

### [Live Demo Link](https://tech-favourites.herokuapp.com/home)

<br>
<!-- ABOUT THE PROJECT -->

## About The Project

A rails app and sorting algorithm that groups passengers together by area and ensures fleets are efficient. Each grouping should get a tag to show that it has an association with a grouping. There are both inbound (from home to work) and outbound (from work to home) trips.

Geocoder was used with the google maps api to geocode the addresses.
PostGIS was used to extend the postgres database to allow for geospacial types and functionality such as distance measurements while keeping the database perfomant.

The algorithm works as follows:

- Bookings with the same locations grouped (Inbound);
- Bookings with the same destination  grouped (Outbound);
- Bookings with the same time slots within inboung/outbound grouped;
- To ensure vehicles are not sent far out for only one booking, the algorithm starts the grouping from the furthest location and works its way in;
- Once the furthest booking is selected, the next booking within a 15km radius, closest to the currently selected booking is selected with it. Else the currently selected is grouped on its own.
- Bookings are iterated through the data until all bookings are sorted into a trip ‘groupings’.

<!-- CONTROL'S -->
## Built With

- Rails
- RSpec
- PostGIS
- Geocoder
- Google Maps API

## How to use

- Upload bookings via csv or add trip locations via the browser with the following headers: [Passenger,Location,Destination,Timeslot]
- The index page shows only the 'home location' of '64 Rigger Rd, Spartan, Kempton Park, 1619'.

### Installation

Ensure the following are installed on your machine

- Ruby
- Redis
- Postgres
- PostGIS

To run the app locally, clone the repository and navigate to it's directory:

```bash
https://github.com/ikraamg/etaPath.git
cd etaPath
bundle install
rails db:create
rails db:migrate
rails db:seed
rails s
```

Find the server, [localhost:3000](http://localhost:3000) in your browser.

### Automated Testing

The app was test with rspec and shoulda-matchers. Run the following code in the root directory of the application

```bash
rspec
```

#### Coverage Report 🧪

Once rspec is run, the coverage report can be found in `/coverage/index.html`.

<!-- CONTACT -->

## Authors

👤 **Ikraam Ghoor**

- Github: [@ikraamg](https://github.com/ikraamg)
- Twitter: [@GhoorIkraam](https://twitter.com/GhoorIkraam)
- LinkedIn: [isghoor](https://linkedin.com/isghoor)
- Email: [consult.ikraam@gmail.com](mailto:consult.ikraam@gmail.com)

## Show your support

Give a ⭐️ if you like this project!

## Acknowledgments

etaPath.com for the project concept

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-shield]: https://img.shields.io/github/contributors/ikraamg/etaPath.svg?style=flat-square
[contributors-url]: https://github.com/ikraamg/etaPath/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/ikraamg/etaPath.svg?style=flat-square
[forks-url]: https://github.com/ikraamg/etaPath/network/members
[stars-shield]: https://img.shields.io/github/stars/ikraamg/etaPath.svg?style=flat-square
[stars-url]: https://github.com/ikraamg/etaPath/stargazers
[issues-shield]: https://img.shields.io/github/issues/ikraamg/etaPath.svg?style=flat-square
[issues-url]: https://github.com/ikraamg/etaPath/issues
