# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
TvShow.delete_all
TvShow.create({"name"=>"Seinfeld", "rating"=>9.3, "photo_url"=>"http://thetvdb.com/banners/posters/79169-5.jpg"})
TvShow.create({"name"=>"The West Wing", "rating"=>9.5, "photo_url"=>"http://thetvdb.com/banners/posters/72521-2.jpg"})
TvShow.create({"name"=>"Person of Interest", "rating"=>9.0, "photo_url"=>"http://thetvdb.com/banners/posters/248742-5.jpg"})
TvShow.create({"name"=>"The Walking Dead", "rating"=>8.8, "photo_url"=>"http://thetvdb.com/banners/posters/153021-12.jpg"})
TvShow.create({"name"=>"24", "rating"=>8.9, "photo_url"=>"http://thetvdb.com/banners/posters/76290-4.jpg"})
TvShow.create({"name"=>"Dexter", "rating"=>9.3, "photo_url"=>"http://thetvdb.com/banners/posters/79349-2.jpg"})
TvShow.create({"name"=>"Breaking Bad", "rating"=>9.3, "photo_url"=>"http://thetvdb.com/banners/posters/81189-2.jpg"})
TvShow.create({"name"=>"Planet Earth", "rating"=>9.5, "photo_url"=>"http://thetvdb.com/banners/posters/79257-1.jpg"})
TvShow.create({"name"=>"The Wire", "rating"=>9.6, "photo_url"=>"http://thetvdb.com/banners/posters/79126-2.jpg"})
TvShow.create({"name"=>"Game of Thrones", "rating"=>9.4, "photo_url"=>"http://thetvdb.com/banners/posters/121361-3.jpg"})
TvShow.create({"name"=>"Firefly", "rating"=>9.5, "photo_url"=>"http://thetvdb.com/banners/posters/78874-2.jpg"})
TvShow.create({"name"=>"Lost", "rating"=>9.1, "photo_url"=>"http://thetvdb.com/banners/posters/73739-11.jpg"})
TvShow.create({"name"=>"The Sopranos", "rating"=>9.2, "photo_url"=>"http://thetvdb.com/banners/posters/75299-3.jpg"})
TvShow.create({"name"=>"Sherlock", "rating"=>9.3, "photo_url"=>"http://thetvdb.com/banners/posters/176941-4.jpg"})
TvShow.create({"name"=>"Twin Peaks", "rating"=>8.8, "photo_url"=>"http://thetvdb.com/banners/posters/70533-7.jpg"})
TvShow.create({"name"=>"Oz", "rating"=>9.1, "photo_url"=>"http://thetvdb.com/banners/posters/70682-1.jpg"})
TvShow.create({"name"=>"Downton Abbey", "rating"=>8.6, "photo_url"=>"http://thetvdb.com/banners/posters/193131-6.jpg"})
TvShow.create({"name"=>"Top Gear", "rating"=>9.6, "photo_url"=>"http://thetvdb.com/banners/posters/74608-5.jpg"})


Movie.delete_all
Movie.create({"name"=>"Argo", "rating"=>95, "user_rating"=>95, "mpaa_rating"=>"R", "description"=>"Based on true events, Argo chronicles the life-or-death covert operation to rescue six Americans, which unfolded behind the scenes of the Iran hostage crisis-the truth of which was unknown by the public for decades. On November 4, 1979, as the Iranian revolution reaches its boiling point, militants storm the U.S. embassy in Tehran, taking 52 Americans hostage. But, in the midst of the chaos, six Americans manage to slip away and find refuge in the home of the Canadian ambassador. Knowing it is only a matter of time before the six are found out and likely killed, a CIA \"exfiltration\" specialist named Tony Mendez (Ben Affleck) comes up with a risky plan to get them safely out of the country. A plan so incredible, it could only happen in the movies. -- (C) Warner Bros.", "poster"=>"http://content9.flixster.com/movie/11/16/69/11166935_det.jpg"})
Movie.create({"name"=>"Perks of being a wallflower", "rating"=>86, "user_rating"=>95, "mpaa_rating"=>"PG-13", "description"=>"Based on the best-selling novel by Stephen Chbosky, The Perks of Being a Wallflower is a modern classic that captures the dizzying highs and crushing lows of growing up. Starring Logan Lerman, Emma Watson and Ezra Miller, The Perks of Being a Wallflower is a moving tale of love, loss, fear and hope-and the unforgettable friends that help us through life. -- (C) Summit", "poster"=>"http://content9.flixster.com/movie/11/16/54/11165471_det.jpg"})
Movie.create({"name"=>"Looper", "rating"=>94, "user_rating"=>88, "mpaa_rating"=>"R", "description"=>"In the futuristic action thriller Looper, time travel will be invented - but it will be illegal and only available on the black market. When the mob wants to get rid of someone, they will send their target 30 years into the past, where a \"looper\" - a hired gun, like Joe (Joseph Gordon-Levitt) - is waiting to mop up. Joe is getting rich and life is good... until the day the mob decides to \"close the loop,\" sending back Joe's future self (Bruce Willis) for assassination. -- (C) Sony", "poster"=>"http://content6.flixster.com/movie/11/16/43/11164348_det.jpg"})
Movie.create({"name"=>"Seven Psychopaths", "rating"=>84, "user_rating"=>81, "mpaa_rating"=>"R", "description"=>"Marty (Farrell) is a struggling writer who dreams of finishing his screenplay, \"Seven Psychopaths\". Billy (Rockwell) is Marty's best friend, an unemployed actor and part time dog thief, who wants to help Marty by any means necessary. All he needs is a little focus and inspiration. Hans (Walken) is Billy's partner in crime. A religious man with a violent past. Charlie (Harrelson) is the psychopathetic gangster whose beloved dog, Billy and Hans have just stolen. Charlie's unpredictable, extremely violent and wouldn't think twice about killing anyone or anything associated with the theft. Marty is going to get all the focus and inspiration he needs, just as long as he lives to tell the tale. -- (C) Official Site", "poster"=>"http://content8.flixster.com/movie/11/16/63/11166338_det.jpg"})
Movie.create({"name"=>"The Dark Knight Rises", "rating"=>87, "user_rating"=>92, "mpaa_rating"=>"PG-13", "description"=>"It has been eight years since Batman vanished into the night, turning, in that instant, from hero to fugitive. Assuming the blame for the death of D.A. Harvey Dent, the Dark Knight sacrificed everything for what he and Commissioner Gordon both hoped was the greater good. For a time the lie worked, as criminal activity in Gotham City was crushed under the weight of the anti-crime Dent Act. But everything will change with the arrival of a cunning cat burglar with a mysterious agenda. Far more dangerous, however, is the emergence of Bane, a masked terrorist whose ruthless plans for Gotham drive Bruce out of his self-imposed exile. But even if he dons the cape and cowl again, Batman may be no match for Bane.. -- (C) Warner Bros.", "poster"=>"http://content9.flixster.com/movie/11/16/53/11165387_det.jpg"})
Movie.create({"name"=>"Avatar", "rating"=>83, "user_rating"=>92, "mpaa_rating"=>"PG-13", "description"=>"", "poster"=>"http://content7.flixster.com/movie/10/91/12/10911201_det.jpg"})
Movie.create({"name"=>"The Dark Knight", "rating"=>94, "user_rating"=>96, "mpaa_rating"=>"PG-13", "description"=>"", "poster"=>"http://content6.flixster.com/movie/11/16/51/11165160_det.jpg"})
Movie.create({"name"=>"Cruel Intentions", "rating"=>48, "user_rating"=>79, "mpaa_rating"=>"R", "description"=>"", "poster"=>"http://content8.flixster.com/movie/11/12/58/11125862_det.jpg"})
Movie.create({"name"=>"The Avengers", "rating"=>92, "user_rating"=>96, "mpaa_rating"=>"PG-13", "description"=>"Marvel Studios presents Marvel's The Avengers-the Super Hero team up of a lifetime, featuring iconic Marvel Super Heroes Iron Man, The Incredible Hulk, Thor, Captain America, Hawkeye and Black Widow. When an unexpected enemy emerges that threatens global safety and security, Nick Fury, Director of the international peacekeeping agency known as S.H.I.E.L.D., finds himself in need of a team to pull the world back from the brink of disaster. Spanning the globe, a daring recruitment effort begins. -- (C) Marvel", "poster"=>"http://content8.flixster.com/movie/11/16/38/11163886_det.jpg"})
Movie.create({"name"=>"Harry Potter", "rating"=>96, "user_rating"=>92, "mpaa_rating"=>"PG-13", "description"=>"Harry Potter and the Deathly Hallows - Part 2, is the final adventure in the Harry Potter film series. The much-anticipated motion picture event is the second of two full-length parts. In the epic finale, the battle between the good and evil forces of the wizarding world escalates into an all-out war. The stakes have never been higher and no one is safe. But it is Harry Potter who may be called upon to make the ultimate sacrifice as he draws closer to the climactic showdown with Lord Voldemort. It all ends here. -- (C) Warner Bros", "poster"=>"http://content9.flixster.com/movie/11/16/36/11163675_det.jpg"})
Movie.create({"name"=>"Iron Man", "rating"=>94, "user_rating"=>91, "mpaa_rating"=>"PG-13", "description"=>"", "poster"=>"http://content7.flixster.com/movie/10/93/35/10933541_det.jpg"})
Movie.create({"name"=>"Spiderman", "rating"=>89, "user_rating"=>65, "mpaa_rating"=>"PG-13", "description"=>"", "poster"=>"http://content7.flixster.com/movie/11/16/52/11165293_det.jpg"})
Movie.create({"name"=>"Titanic", "rating"=>87, "user_rating"=>69, "mpaa_rating"=>"PG-13", "description"=>"", "poster"=>"http://content6.flixster.com/movie/11/16/63/11166320_det.jpg"})
Movie.create({"name"=>"The Texas Chainsaw Massacre", "rating"=>12, "user_rating"=>64, "mpaa_rating"=>"R", "description"=>"", "poster"=>"http://content7.flixster.com/movie/11/13/31/11133153_det.jpg"})
Movie.create({"name"=>"I am Legend", "rating"=>70, "user_rating"=>69, "mpaa_rating"=>"PG-13", "description"=>"", "poster"=>"http://content6.flixster.com/movie/11/16/67/11166780_det.jpg"})
Movie.create({"name"=>"Lord of the Rings", "rating"=>94, "user_rating"=>83, "mpaa_rating"=>"PG-13", "description"=>"", "poster"=>"http://content9.flixster.com/movie/11/16/64/11166423_det.jpg"})
Movie.create({"name"=>"The Mummy", "rating"=>13, "user_rating"=>40, "mpaa_rating"=>"PG-13", "description"=>"", "poster"=>"http://content8.flixster.com/movie/10/87/58/10875846_det.jpg"})

