puts "Cleaning up database..."
Exhibitor.destroy_all
Entreprise.destroy_all
Event.destroy_all
puts "Database cleaned"

organisateur = Entreprise.create(
    name: "Orgnisateur",
    email: "organisateur@dannacode.com",
    website: "www.dannacode.com",
    linkedin: "www.linkdin.com",
    instagram: "www.instagram.com",
    facebook: "www.facebook.com",
    twitter: "www.twiter.com",
    description: "Le secret pour être millionnaire, et de simplement déléguer ce que nous savons pas faire."
)

dannacode = Entreprise.create(
    name: "DannaCode",
    email: "christophe.danna@dannacode.com",
    website: "www.dannacode.com",
    linkedin: "www.linkdin.com",
    instagram: "www.instagram.com",
    facebook: "www.facebook.com",
    twitter: "www.twiter.com",
    description: "Plus grande entreprise de France, vous souhaitez un site d'exeption ? C'est ici et nul part ailleurs !"
)
maelcorp = Entreprise.create(
    name: "MaelCorp",
    email: "mael@dannacode.com",
    website: "www.maelcorp.com",
    linkedin: "www.linkdin.com",
    instagram: "www.instagram.com",
    facebook: "www.facebook.com",
    twitter: "www.twiter.com",
    description: "Plus grande entreprise de France, vous souhaitez un site d'exeption ? C'est ici et nul part ailleurs !"
)
jeux = Event.create(
    title: "Festival des jeux",
    address: "47 rue Saint-Georges",
    city: "Paris",
    country: "France",
    link: "www.cannesticket.com/fr",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
    start_time: "2024-04-05",
    end_time: "2024-04-07",
    registration_code: "QWERTY",
    entreprise: organisateur
)

play = Event.create(
    title: "Festival des jeux",
    address: "1 Bd de la Croisette",
    city: "Cannes",
    country: "France",
    link: "www.cannesticket.com/fr",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
    start_time: "2024-05-23",
    end_time: "2024-05-25",
    registration_code: "QWERTY",
    entreprise: organisateur
)

Exhibitor.create(entreprise: dannacode, event: jeux)
Exhibitor.create(entreprise: maelcorp, event: jeux)
Exhibitor.create(entreprise: dannacode, event: play)
Exhibitor.create(entreprise: maelcorp, event: play)

puts "finish"