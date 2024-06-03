-- Popolare Categoria
insert into Categoria (nome) values 
('Musica'),
('Film'),
('Documentari'),
('Sport'),
('Tecnologia');

-- Popolare Tag
insert into Tag (nome) values 
('educativo'),
('divertente'),
('musica'),
('sport'),
('tecnologia'),
('film');

-- Popolare MotivazioneCensura
insert into MotivazioneCensura (nome, descrizione) values 
('Violenza', 'Contenuti violenti non adatti al pubblico'),
('Nudità', 'Contenuti di nudità non appropriati'),
('Hate Speech', 'Contenuti offensivi e di incitamento all odio');

-- Popolare Utente
insert into Utente (nome, dataIscrizione) values 
('utente1', '2022-01-15 10:00:00'),
('utente2', '2022-02-20 11:30:00'),
('utente3', '2022-03-25 14:45:00'),
('utente4', '2022-04-30 16:00:00'),
('utente5', '2022-05-10 09:15:00');

-- Popolare Video
insert into Video (titolo, descrizione, file, istante_pubblicazione, autore, categoria, super_vid) values 
('Video di Musica', 'Un bellissimo video musicale', '\\x00', '2022-06-01 12:00:00', 'utente1', 'Musica', NULL),
('Video di Sport', 'Un fantastico video sportivo', '\\x00', '2022-06-02 13:00:00', 'utente2', 'Sport', NULL),
('Video di Tecnologia', 'Un interessante video tecnologico', '\\x00', '2022-06-03 14:00:00', 'utente3', 'Tecnologia', NULL),
('Video Documentario', 'Un documentario affascinante', '\\x00', '2022-06-04 15:00:00', 'utente4', 'Documentari', NULL),
('Video di Film', 'Un film emozionante', '\\x00', '2022-06-05 16:00:00', 'utente5', 'Film', NULL);

-- Popolare tagVid
insert into tagVid (video, tag) values 
(1, 'musica'),
(2, 'sport'),
(3, 'tecnologia'),
(4, 'educativo'),
(5, 'film');

-- Popolare VideoCensurato
insert into VideoCensurato (video, commentoAggiuntivo, dataCensura, motivazione) values 
(1, 'Contenuti non appropriati', '2023-01-01 10:00:00', 'Violenza');

-- Popolare Cronologia
insert into Cronologia (dataVisualizzazione, utente, video) values 
('2023-02-01 11:00:00', 'utente1', 1),
('2023-02-02 12:00:00', 'utente2', 2),
('2023-02-03 13:00:00', 'utente3', 3),
('2023-02-04 14:00:00', 'utente4', 4),
('2023-02-05 15:00:00', 'utente5', 5);

-- Popolare Valutazione
insert into Valutazione (utente, video, voto, dataValutazione) values 
('utente1', 1, 5, '2023-02-01 11:00:00'),
('utente2', 2, 4, '2023-02-02 12:00:00'),
('utente3', 3, 3, '2023-02-03 13:00:00'),
('utente4', 4, 2, '2023-02-04 14:00:00'),
('utente5', 5, 1, '2023-02-05 15:00:00');

-- Popolare Commento
insert into Commento (testo, dataPubblicazione, utente, video) values 
('Ottimo video!', '2023-02-01 11:05:00', 'utente1', 1),
('Molto interessante', '2023-02-02 12:05:00', 'utente2', 2),
('Mi è piaciuto molto', '2023-02-03 13:05:00', 'utente3', 3),
('Un po noioso', '2023-02-04 14:05:00', 'utente4', 4),
('Non mi è piaciuto', '2023-02-05 15:05:00', 'utente5', 5);

-- Popolare Playlist
insert into Playlist (nome, dataCreazione, stato, utente) values 
('Playlist Musica', '2023-03-01 10:00:00', 'Pubblica', 'utente1'),
('Playlist Sport', '2023-03-02 11:00:00', 'Privata', 'utente2'),
('Playlist Tecnologia', '2023-03-03 12:00:00', 'Pubblica', 'utente3'),
('Playlist Documentari', '2023-03-04 13:00:00', 'Privata', 'utente4'),
('Playlist Film', '2023-03-05 14:00:00', 'Pubblica', 'utente5');

-- Popolare plVid
insert into plVid (playlist, video, dataInserimento) values 
(1, 1, '2023-03-01 10:05:00'),
(2, 2, '2023-03-02 11:05:00'),
(3, 3, '2023-03-03 12:05:00'),
(4, 4, '2023-03-04 13:05:00'),
(5, 5, '2023-03-05 14:05:00');


insert into Video (titolo, descrizione, file, istante_pubblicazione, autore, categoria, super_vid) values 
('Video Risposta di Musica', 'Un bellissimo video musicale', '\\x00', '2022-06-02 12:00:00', 'utente2', 'Musica', 1),
('Video Risposta di Sport1', 'Un fantastico video sportivo', '\\x00', '2022-06-03 13:00:00', 'utente1', 'Sport', 2),
('Video Risposta di Sport2', 'Un interessante video tecnologico', '\\x00', '2022-06-04 14:00:00', 'utente1', 'Sport', 2)