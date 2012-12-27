# -*- coding: utf-8 -*-

TvShow.delete_all
Movie.delete_all
Genre.delete_all
Genre.create([{:name => "Action"}, {:name => "Adventure"}, {:name=>"Action and Adventure"}, {:name=>"Comedy"}, {:name=>"Drama"}, {:name=>"Fantasy"}, {:name=>"Soap"}, {:name=>"Talk Show"}, {:name=>"Animation"}, {:name=>"Science-Fiction"}, {:name=>"Children"}, {:name=>"Western"}, {:name=>"Mini-Series"}, {:name=>"Documentary"}, {:name=>"Special Interest"}, {:name=>"News"}, {:name=>"Game Show"}, {:name=>"Sport"}, {:name=>"Reality"}, {:name=>"Home and Garden"}, {:name=>"Mini-series"}])

# TvShow.create({"name"=>"Seinfeld", "rating"=>9.3, "poster"=>"http://thetvdb.com/banners/posters/79169-5.jpg"})
# TvShow.create({"name"=>"The West Wing", "rating"=>9.5, "poster"=>"http://thetvdb.com/banners/posters/72521-2.jpg"})
# TvShow.create({"name"=>"Person of Interest", "rating"=>9.0, "poster"=>"http://thetvdb.com/banners/posters/248742-5.jpg"})
# TvShow.create({"name"=>"The Walking Dead", "rating"=>8.8, "poster"=>"http://thetvdb.com/banners/posters/153021-12.jpg"})
# TvShow.create({"name"=>"24", "rating"=>8.9, "poster"=>"http://thetvdb.com/banners/posters/76290-4.jpg"})
# TvShow.create({"name"=>"Dexter", "rating"=>9.3, "poster"=>"http://thetvdb.com/banners/posters/79349-2.jpg"})
# TvShow.create({"name"=>"Breaking Bad", "rating"=>9.3, "poster"=>"http://thetvdb.com/banners/posters/81189-2.jpg"})
# TvShow.create({"name"=>"Planet Earth", "rating"=>9.5, "poster"=>"http://thetvdb.com/banners/posters/79257-1.jpg"})
# TvShow.create({"name"=>"The Wire", "rating"=>9.6, "poster"=>"http://thetvdb.com/banners/posters/79126-2.jpg"})
# TvShow.create({"name"=>"Game of Thrones", "rating"=>9.4, "poster"=>"http://thetvdb.com/banners/posters/121361-3.jpg"})
# TvShow.create({"name"=>"Firefly", "rating"=>9.5, "poster"=>"http://thetvdb.com/banners/posters/78874-2.jpg"})
# TvShow.create({"name"=>"Lost", "rating"=>9.1, "poster"=>"http://thetvdb.com/banners/posters/73739-11.jpg"})
# TvShow.create({"name"=>"The Sopranos", "rating"=>9.2, "poster"=>"http://thetvdb.com/banners/posters/75299-3.jpg"})
# TvShow.create({"name"=>"Sherlock", "rating"=>9.3, "poster"=>"http://thetvdb.com/banners/posters/176941-4.jpg"})
# TvShow.create({"name"=>"Twin Peaks", "rating"=>8.8, "poster"=>"http://thetvdb.com/banners/posters/70533-7.jpg"})
# TvShow.create({"name"=>"Oz", "rating"=>9.1, "poster"=>"http://thetvdb.com/banners/posters/70682-1.jpg"})
# TvShow.create({"name"=>"Downton Abbey", "rating"=>8.6, "poster"=>"http://thetvdb.com/banners/posters/193131-6.jpg"})
# TvShow.create({"name"=>"Top Gear", "rating"=>9.6, "poster"=>"http://thetvdb.com/banners/posters/74608-5.jpg"})

# Movie.create({"name"=>"Armageddon", "rating"=>39, "certified"=>false, "user_rating"=>77, "mpaa_rating"=>"PG-13", "description"=>"An asteroid the size of Texas is heading directly toward Earth at 22,000 mph. NASA's executive director, Dan Truman, has only one option - to send up a crew to destroy the asteroid. He enlists the help of Harry S. Stamper - the world's foremost deep core oil driller - and Stamper's roughneck team of drillers to land on the asteroid, drill into its surface, and drop a nuclear device.", "popularity"=>14413.497, "poster"=>"http://content7.flixster.com/movie/55/05/68/5505685_det.jpg", "release_date"=>"1998-07-01", "rt_id"=>"17022", "runtime"=>151}).genres.push(Genre.where{ name >>["Action", "Science Fiction", "Thriller"]})
# Movie.create({"name"=>"Beverly Hills Cop II", "rating"=>46, "certified"=>false, "user_rating"=>63, "mpaa_rating"=>"R", "description"=>"Axel Foley is back and as funny as ever in this fast-paced sequel to the original smash hit. This time, the Detroit cop heads for the land of sunshine and palm trees to find out who shot police Captain Andrew Bogomil. Thanks to a couple of old friends, Axel's investigation uncovers a series of robberies masterminded by a heartless weapons kingpin, and the chase is on!", "popularity"=>426.554, "poster"=>"http://content7.flixster.com/movie/10/84/44/10844413_det.jpg", "release_date"=>"1987-05-20", "rt_id"=>"13834", "runtime"=>98}).genres.push(Genre.where{ name >>["Action", "Comedy", "Crime"]})
# Movie.create({"name"=>"TRON", "rating"=>70, "certified"=>false, "user_rating"=>66, "mpaa_rating"=>"PG", "description"=>"As Kevin Flynn searches his work computer for classified information relating to video games, he is \"digitalized\" by a laser and finds himself actually inside the computer, where people are programs and criminals are computer viruses. Tron is the first feature film to have long computer generated scenes and thus, is seen as a milestone in cinematic history.", "popularity"=>62.307, "poster"=>"http://content6.flixster.com/movie/10/91/41/10914152_det.jpg", "release_date"=>"1982-07-09", "rt_id"=>"12120", "runtime"=>96}).genres.push(Genre.where{ name >>["Action", "Adventure", "Science Fiction", "Thriller"]})
# Movie.create({"name"=>"Gladiator", "rating"=>78, "certified"=>true, "user_rating"=>85, "mpaa_rating"=>"R", "description"=>"Gladiator is an epic film of love, death and betrayal set in the Roman Empire. General Maximus' success in battle earns the favour of an elderly Emperor at the expense of the Emperor's son. In a fit of jealous rage the son slays his father before turning his anger towards Maximus. Now reduced to a slave, his family dead, Maximus must fight as a Gladiator to gain his freedom, and his revenge.", "popularity"=>52298.659, "poster"=>"http://content8.flixster.com/movie/10/80/17/10801794_det.jpg", "release_date"=>"2000-05-05", "rt_id"=>"13065", "runtime"=>171}).genres.push(Genre.where{ name >>["Action", "Adventure", "Drama"]})
# Movie.create({"name"=>"All About My Mother", "rating"=>98, "certified"=>true, "user_rating"=>92, "mpaa_rating"=>"R", "description"=>"All About My Mother / Todo Sobre Mi Madre – Pedro Almodóvar tells the story of a woman searching for the father of her son as she is confronted with her past. This homage to the mother enticed two million Spaniards into the theaters.", "popularity"=>2.621, "poster"=>"http://content7.flixster.com/movie/10/95/09/10950921_det.jpg", "release_date"=>"1999-04-16", "rt_id"=>"13481", "runtime"=>101}).genres.push(Genre.where{ name >>["Comedy", "Drama", "Foreign"]})
# Movie.create({"name"=>"Taxi Driver", "rating"=>98, "certified"=>true, "user_rating"=>93, "mpaa_rating"=>"R", "description"=>"Robert De Niro stars as Travis Bickle in this oppressive psychodrama about a Vietnam veteran who rebels against the decadence and immorality of big city life in New York while working the nightshift as a taxi driver.", "popularity"=>4946.927, "poster"=>"http://content7.flixster.com/movie/11/15/78/11157877_det.jpg", "release_date"=>"1976-02-08", "rt_id"=>"16625", "runtime"=>112}).genres.push(Genre.where{ name >>["Crime", "Drama", "Thriller"]})
# Movie.create({"name"=>"Back to the Future", "rating"=>97, "certified"=>true, "user_rating"=>88, "mpaa_rating"=>"PG", "description"=>"Eighties teenager Marty McFly is accidentally sent back in time to 1955, inadvertently disrupting his parents' first meeting and attracting his mother's romantic interest. Marty must repair the damage to history by rekindling his parents' romance and - with the help of his eccentric inventor friend Doc Brown - returning to 1985.", "popularity"=>69205.222, "poster"=>"http://content6.flixster.com/movie/31/17/311700_det.jpg", "release_date"=>"1985-07-03", "rt_id"=>"23532", "runtime"=>116}).genres.push(Genre.where{ name >>["Adventure", "Comedy", "Science Fiction", "Family"]})
# Movie.create({"name"=>"Predator", "rating"=>77, "certified"=>false, "user_rating"=>83, "mpaa_rating"=>"R", "description"=>"Dutch and his group of commandos are hired by the CIA to rescue downed airmen from guerillas in a Central American jungle. The mission goes well but as they return they find that something is hunting them. Nearly invisible, it blends in with the forest, taking trophies from the bodies of it's victims as it goes along. Occasionally seeing through it's eyes, the audience sees it is an intelligent alien hunter, hunting them for sport, killing them off one at a time.", "popularity"=>10121.869, "poster"=>"http://content7.flixster.com/movie/11/16/49/11164941_det.jpg", "release_date"=>"1987-06-12", "rt_id"=>"16751", "runtime"=>107}).genres.push(Genre.where{ name >>["Action", "Adventure", "Horror", "Science Fiction"]})
# Movie.create({"name"=>"Pretty Woman", "rating"=>62, "certified"=>false, "user_rating"=>68, "mpaa_rating"=>"R", "description"=>"When millionaire wheeler-dealer Edward Lewis enters a business contract with Hollywood hooker Vivian Ward, he loses his heart in the bargain in this charming romantic comedy. After Edward hires Vivian as his date for a week and gives her a Cinderella makeover, she returns the favor by mellowing the hardnosed tycoon's outlook. Can the poor prostitute and the rich capitalist live happily ever after?", "popularity"=>0.466, "poster"=>"http://content8.flixster.com/movie/16/90/52/1690526_det.jpg", "release_date"=>"1990-03-23", "rt_id"=>"13006", "runtime"=>117}).genres.push(Genre.where{ name >>["Comedy", "Romance"]})
# Movie.create({"name"=>"The Big Lebowski", "rating"=>80, "certified"=>true, "user_rating"=>93, "mpaa_rating"=>"R", "description"=>"Jeffrey \"The Dude\" Lebowski is the ultimate LA slacker, until one day his house is broken into and his rug is peed on by two angry gangsters who have mistaken him for Jeffrey Lebowski, the LA millionaire, whose wife owes some bad people some big money. The Dude becomes entangled in the plot when he goes to visit the real Lebowski in order to get some retribution for his soiled rug, and is recruited to be the liason between Lebowski and the captors of his now \"kidnapped\" wife.", "popularity"=>31730.333, "poster"=>"http://content6.flixster.com/movie/10/95/21/10952108_det.jpg", "release_date"=>"1998-03-06", "rt_id"=>"14281", "runtime"=>118}).genres.push(Genre.where{ name >>["Comedy", "Crime"]})
# Movie.create({"name"=>"Match Point", "rating"=>77, "certified"=>true, "user_rating"=>78, "mpaa_rating"=>"R", "description"=>"Match Point is Woody Allen’s satire of the British High Society and the ambition of a young tennis instructor to enter into it. Yet when he must decide between two women - one assuring him his place in high society, and the other that would bring him far from it - palms start to sweat and a dark psychological match in his head begins.", "popularity"=>33.544, "poster"=>"http://content7.flixster.com/movie/10/89/54/10895469_det.jpg", "release_date"=>"2005-12-28", "rt_id"=>"24478", "runtime"=>124}).genres.push(Genre.where{ name >>["Crime", "Drama", "Thriller", "Romance"]})
# Movie.create({"name"=>"The Untouchables", "rating"=>81, "certified"=>true, "user_rating"=>87, "mpaa_rating"=>"R", "description"=>"Young Treasury Agent Elliot Ness arrives in Chicago and is deternimed to take down Al Capone but it's not going to be easy, because Capone has the police in his pocket. Ness meets Jimmy Malone a veteran patrolman and probably the most honorable one in the force. He asks Malone to help him get Capone but Malone warns him that if he goes after Capone, he is going to war.", "popularity"=>335.207, "poster"=>"http://content8.flixster.com/movie/27/92/279214_det.jpg", "release_date"=>"1987-06-02", "rt_id"=>"15394", "runtime"=>119}).genres.push(Genre.where{ name >>["Action", "Crime", "Drama", "History", "Thriller"]})
# Movie.create({"name"=>"Charlie and the Chocolate Factory", "rating"=>82, "certified"=>true, "user_rating"=>52, "mpaa_rating"=>"PG", "description"=>"A young boy wins a tour through the most magnificent chocolate factory in the world, led by the world's most unusual candy maker.", "popularity"=>2974.49, "poster"=>"http://content7.flixster.com/movie/24/98/249821_det.jpg", "release_date"=>"2005-07-15", "rt_id"=>"1965", "runtime"=>130}).genres.push(Genre.where{ name >>["Adventure", "Comedy", "Fantasy", "Science Fiction", "Family"]})
# Movie.create({"name"=>"The Lord of the Rings: The Fellowship of the Ring", "rating"=>92, "certified"=>true, "user_rating"=>92, "mpaa_rating"=>"PG-13", "description"=>"Young hobbit Frodo Baggins, after inheriting a mysterious ring from his uncle Bilbo, must leave his home in order to keep it from falling into the hands of its evil creator. Along the way, a fellowship is formed to protect the ringbearer and make sure that the ring arrives at its final destination: Mt. Doom, the only place where it can be destroyed.", "popularity"=>193447.424, "poster"=>"http://content6.flixster.com/movie/11/16/64/11166420_det.jpg", "release_date"=>"2001-12-19", "rt_id"=>"12769", "runtime"=>165}).genres.push(Genre.where{ name >>["Action", "Adventure", "Fantasy", "Science Fiction"]})
# Movie.create({"name"=>"The Lord of the Rings: The Two Towers", "rating"=>96, "certified"=>true, "user_rating"=>92, "mpaa_rating"=>"PG-13", "description"=>"Frodo and Sam are trekking to Mordor to destroy the One Ring of Power while Gimli, Legolas and Aragorn search for the orc-captured Merry and Pippin. All along, nefarious wizard Saruman awaits the Fellowship members at the Orthanc Tower in Isengard.", "popularity"=>132316.445, "poster"=>"http://content7.flixster.com/movie/11/16/64/11166421_det.jpg", "release_date"=>"2002-12-12", "rt_id"=>"10513", "runtime"=>180}).genres.push(Genre.where{ name >>["Action", "Adventure", "Fantasy", "Science Fiction"]})
# Movie.create({"name"=>"The Lord of the Rings: The Return of the King", "rating"=>94, "certified"=>true, "user_rating"=>83, "mpaa_rating"=>"PG-13", "description"=>"Aragorn is revealed as the heir to the ancient kings as he, Gandalf and the other members of the broken fellowship struggle to save Gondor from Sauron's forces. Meanwhile, Frodo and Sam bring the ring closer to the heart of Mordor, the dark lord's realm.", "popularity"=>236317.581, "poster"=>"http://content9.flixster.com/movie/11/16/64/11166423_det.jpg", "release_date"=>"2003-12-17", "rt_id"=>"10156", "runtime"=>201}).genres.push(Genre.where{ name >>["Action", "Adventure", "Drama", "Fantasy", "Science Fiction"]})
# Movie.create({"name"=>"The Lord of the Rings", "rating"=>48, "certified"=>false, "user_rating"=>74, "mpaa_rating"=>"PG", "description"=>"An animated fantasy film from 1978 based on the first half of J.R.R Tolkien’s Lord of the Rings novel. The film was mainly filmed using rotoscoping, meaning it was filmed in live action sequences with real actors and then each frame was individually animated.", "popularity"=>0.076, "poster"=>"http://content7.flixster.com/movie/11/15/29/11152973_det.jpg", "release_date"=>"1978-11-15", "rt_id"=>"11649", "runtime"=>132}).genres.push(Genre.where{ name >>["Adventure", "Animation", "Drama", "Fantasy", "Science Fiction", "Family"]})
# Movie.create({"name"=>"Gimme Shelter", "rating"=>100, "certified"=>false, "user_rating"=>90, "mpaa_rating"=>"R", "description"=>"This documentary of the Rolling Stones' 1969 US tour has become a legendary, harrowing symbol of the tragic demise of the \"Peace and Love\" era. After a successful tour across the US, the Rolling Stones gave a free December concert at Altamont Speedway in California with the Grateful Dead, Ike and Tina Turner, Jefferson Airplane, and the Flying Burrito Brothers. The band unwisely selected the Hells Angels to provide security, and the bikers resorted to violence to keep the stoned, restless, and often naked crowd in line. The result: dozens of injuries and the on-screen stabbing of a young black man (during \"Sympathy for the Devil\") by one of the concert's staff security. In a manipulative but effective move, the Maysles brothers filmed Mick Jagger in the editing room witnessing the on-camera murder for the first time. The film also works as a rock-and-roll document, capturing the band at their most relaxed, intoxicating, and electrifying.", "popularity"=>0.004, "poster"=>"http://content6.flixster.com/movie/10/88/57/10885780_det.jpg", "release_date"=>"1970-12-06", "rt_id"=>"243296671", "runtime"=>95}).genres.push(Genre.where{ name >>["Documentary", "Music"]})
# Movie.create({"name"=>"O Brother, Where Art Thou?", "rating"=>77, "certified"=>true, "user_rating"=>87, "mpaa_rating"=>"PG-13", "description"=>"O’Brother, Where Art Thou? Is a Coen Brother's film roughly based on Homer’s “Odyssey.” Taking place in the deep south in the 1930’s the film tells the story of three escaped prison workers and their journey for a buried treasure. On their journey they come across many comical characters and incredible situations.", "popularity"=>1027.025, "poster"=>"http://content7.flixster.com/movie/97/83/14/9783145_det.jpg", "release_date"=>"2000-12-22", "rt_id"=>"12776", "runtime"=>106}).genres.push(Genre.where{ name >>["Action", "Adventure", "Comedy", "Musical"]})
# Movie.create({"name"=>"Freaks", "rating"=>93, "certified"=>false, "user_rating"=>87, "mpaa_rating"=>"Unrated", "description"=>"A beautiful trapeze artist agrees to marry the dwarf leader of a circus side-show, but his deformed friends discover she is only marrying him for his inheritance.", "popularity"=>0.036, "poster"=>"http://content7.flixster.com/movie/56/75/62/5675629_det.jpg", "release_date"=>"1932-02-20", "rt_id"=>"17030", "runtime"=>64}).genres.push(Genre.where{ name >>["Drama", "Horror", "Thriller"]})


User.create({"email"=>"aeggum12@gmail.com", "password"=>"adameggum", "admin"=>true})


