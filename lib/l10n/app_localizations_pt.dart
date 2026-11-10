// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get checkInEnter => 'Fazer check-in aqui e entrar';

  @override
  String get checkInNote =>
      'Ao tocar, as pessoas por perto verão seu humor e mais ou menos onde você está. Você faz o check-in sozinho toda vez que entra.';

  @override
  String get checkInTitle => 'Faça check-in na cidade';

  @override
  String get checkInBody =>
      'Depois do check-in, as pessoas por perto podem ver seu humor e mais ou menos onde você está, e você também as vê. Elas veem o lugar onde você fez o check-in; ele não acompanha você. Você faz o check-in sozinho toda vez que abre o app; nunca acontece automaticamente. Sair ou trocar para outro app encerra o check-in.';

  @override
  String get checkInButton => 'Fazer check-in aqui';

  @override
  String get checkInAgain =>
      'Você saiu do lugar do check-in · Fazer check-in aqui';

  @override
  String get checkOutButton => 'Check-in feito · Sair';

  @override
  String get checkedOutToast => 'Check-out feito. Você não está mais no mapa.';

  @override
  String get appName => 'Mood Whisper';

  @override
  String get moodJoy => 'Feliz';

  @override
  String get moodSad => 'Triste';

  @override
  String get moodAngry => 'Bravo';

  @override
  String get moodCalm => 'Calmo';

  @override
  String get moodPassion => 'Animado';

  @override
  String get moodLove => 'Amor';

  @override
  String get moodOther => 'Outro';

  @override
  String gatheringEnded(String emoji, String name) {
    return '$emoji $name terminou';
  }

  @override
  String handedOffStillJoined(String emoji, String name) {
    return 'Você passou $emoji $name adiante e agora é participante.';
  }

  @override
  String handedOffNicknameFull(String emoji) {
    return 'Você passou o encontro adiante. Seu nome já tem 10 caracteres, então adicione $emoji você mesmo para continuar recebendo avisos.';
  }

  @override
  String handedOffEmojiAdded(String emoji) {
    return 'Você passou o encontro adiante. Adicionamos $emoji ao seu nome, então agora você é participante.';
  }

  @override
  String get gotIt => 'Entendi';

  @override
  String get blockedToast => 'Esta pessoa sumiu na escuridão.';

  @override
  String get unblockedToast =>
      'Desbloqueado. Seus caminhos podem se cruzar de novo.';

  @override
  String notificationToast(String title, String body) {
    return '$title: $body';
  }

  @override
  String get locationServiceOffTitle => 'Ative os Serviços de Localização';

  @override
  String get locationServiceOffBody =>
      'O Mood Whisper precisa saber em que canto da cidade você está para que as pessoas por perto vejam seu humor. Ative os Serviços de Localização nos Ajustes do celular.';

  @override
  String get locationReducedTitle => 'Ative a Localização Precisa';

  @override
  String get locationReducedBodyIos =>
      'Você está compartilhando só uma localização aproximada, então o radar não consegue saber quem está perto. Vá em Ajustes › Mood Whisper › Localização e ative Localização Precisa.';

  @override
  String get locationReducedBodyAndroid =>
      'Você está compartilhando só uma localização aproximada, então o radar não consegue saber quem está perto. Escolha Precisa na permissão de localização.';

  @override
  String get locationNoFixTitle => 'Ainda não encontramos sua localização';

  @override
  String get locationNoFixBody =>
      'Você pode estar em um lugar fechado ou com sinal fraco. Vá para perto de uma janela ou para fora, ative o Wi-Fi e tente de novo.';

  @override
  String get locationNeededTitle => 'O Mood Whisper precisa da sua localização';

  @override
  String get locationNeededBody =>
      'O Mood Whisper só usa sua localização enquanto você usa o app, para mostrar humores em até 5 km. O radar mostra distâncias aproximadas, nunca endereços.\nNos Ajustes, permita a localização Durante o Uso do App e ative a Localização Precisa.';

  @override
  String get locationSimulatorHint =>
      '(Nota para desenvolvedores: no Simulador, escolha um local em Features › Location)';

  @override
  String get openSettings => 'Abrir Ajustes';

  @override
  String get locationRecheck => 'Já ativei, verificar de novo';

  @override
  String get tryAgain => 'Tentar de novo';

  @override
  String get leaveApp => 'Sair';

  @override
  String whispersNearby(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Há $count sussurros perto de você. Toque em um envelope para ler.',
      one: 'Há 1 sussurro perto de você. Toque no envelope para ler.',
    );
    return '$_temp0';
  }

  @override
  String get whisperPassed =>
      'Você passou por um sussurro. Toque no envelope para ler.';

  @override
  String get whisperLeft => 'Seu sussurro está aqui agora. Ele some em 7 dias.';

  @override
  String get timeWhisperSealedYear =>
      'Selado. Volte aqui daqui a um ano para abrir.';

  @override
  String get timeWhisperSealedMonth =>
      'Selado. Volte aqui daqui a um mês para abrir.';

  @override
  String get whisperWithdrawn => 'Seu sussurro foi retirado.';

  @override
  String get whisperMineLabel => 'Um sussurro que você deixou';

  @override
  String get whisperTapToRead => 'Um sussurro. Toque para ler';

  @override
  String get noMoodYet => 'Sem palavras…';

  @override
  String get knockWithdrawnByLeaving =>
      'A pessoa voltou para a cidade e retirou a batida em silêncio…';

  @override
  String get knockCardTitle => 'Um cruzamento de instantes';

  @override
  String knockCardBody(String name) {
    return '$name está batendo à porta,\ntorcendo para seus caminhos se cruzarem…';
  }

  @override
  String get skip => 'Pular';

  @override
  String get decline => 'Recusar';

  @override
  String get accept => 'Aceitar';

  @override
  String get reportThisPerson => 'Denunciar esta pessoa';

  @override
  String get cityQuietTonight => 'A cidade está tranquila esta noite';

  @override
  String cityMoodChip(String mood, String percent) {
    return 'A cidade hoje · $mood $percent%';
  }

  @override
  String cityMoodChipLabel(String text) {
    return '$text. Ver o clima de humor da cidade';
  }

  @override
  String get cityMoodTitle => 'O humor da cidade esta noite';

  @override
  String cityMoodQuietCount(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other:
          'A cidade ainda está tranquila. $total pessoas compartilharam o humor esta noite.',
      one: 'A cidade ainda está tranquila. 1 pessoa compartilhou o humor esta noite.',
    );
    return '$_temp0';
  }

  @override
  String cityMoodCount(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total pessoas a até 20 km compartilharam o humor esta noite',
      one: '1 pessoa a até 20 km compartilhou o humor esta noite',
    );
    return '$_temp0';
  }

  @override
  String get cityMoodQuietInvite =>
      'Cada humor acende um pouco de luz. Escreva como você está agora e ajude a iluminar a cidade.';

  @override
  String get cityMoodFootnote =>
      'Humores anônimos das últimas 24 horas. As porcentagens ficam ocultas quando menos de 10 pessoas participaram.';

  @override
  String get close => 'Fechar';

  @override
  String get emptyRadarTitle => 'Você é a primeira luz desta noite';

  @override
  String get emptyRadarBody =>
      'Ainda não há ninguém por perto. Seu humor já está brilhando na cidade,\ne quem passar vai vê-lo. Você também pode deixar um sussurro para a próxima pessoa que passar.';

  @override
  String emptyRadarCityMood(String total, String mood) {
    return '$total pessoas estão na cidade esta noite, e a maioria se sente “$mood”';
  }

  @override
  String get inviteFriends => 'Convide amigos para iluminar seu bairro';

  @override
  String get shareMoodCard => 'Compartilhar meu cartão de humor';

  @override
  String get editYourMood => 'Editar seu humor';

  @override
  String resonanceTonight(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count brilhos ressoaram com você esta noite',
      one: '1 brilho ressoou com você esta noite',
    );
    return '$_temp0';
  }

  @override
  String dockNicknameMood(String nickname) {
    return '$nickname · seu humor';
  }

  @override
  String get dockTapToEdit => 'Seu humor · toque para editar';

  @override
  String get leaveWhisper => 'Deixar um sussurro';

  @override
  String get settings => 'Ajustes';

  @override
  String get nightlyReminder => 'Lembrete noturno';

  @override
  String get nightlyReminderSubtitle =>
      'Um lembrete gentil às 21:30 toda noite';

  @override
  String get closeSettings => 'Fechar ajustes';

  @override
  String get settingsSectionMe => 'Eu';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get editProfileSubtitle => 'Foto, nome na cidade e humor';

  @override
  String get manageBlockList => 'Pessoas bloqueadas';

  @override
  String get manageBlockListSubtitle =>
      'Veja ou desbloqueie quem você mandou para a escuridão';

  @override
  String get myTimeWhispers => 'Minhas cartas para o futuro';

  @override
  String get myTimeWhispersSubtitle =>
      'Recados para você no futuro que só você vê';

  @override
  String get myMoodTrail => 'Minha trilha de humor';

  @override
  String get myMoodTrailSubtitle => 'Guardada só no seu celular';

  @override
  String get settingsSectionGatherings => 'Encontros';

  @override
  String get gatheringHost => 'Organizar um encontro';

  @override
  String get gatheringHostSubtitle =>
      'Crie um evento para todos a até 5 km de você';

  @override
  String gatheringHosting(String emoji, String name) {
    return 'Você está organizando $emoji $name';
  }

  @override
  String get settingsSectionShare => 'Compartilhar';

  @override
  String get shareMoodCardSubtitle =>
      'Uma de onze ilustrações noturnas ao acaso, feita para os Stories do Instagram';

  @override
  String get inviteFriendsSubtitle =>
      'Quanto mais gente por perto, mais iluminada a cidade';

  @override
  String get settingsSectionAbout => 'Sobre';

  @override
  String get guide => 'Como usar';

  @override
  String get guideSubtitle =>
      'Tudo, de escrever um humor a organizar um encontro';

  @override
  String get termsOfUse => 'Termos de Uso';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get contactUs => 'Fale conosco';

  @override
  String get deleteAccount => 'Excluir conta e dados';

  @override
  String get deleteAccountSubtitle =>
      'Apague para sempre tudo o que você deixou na cidade';

  @override
  String get avatarUploadFailed =>
      'Sua foto não foi enviada. Tente mais tarde.';

  @override
  String get moodEmpty =>
      'Seu humor não pode ficar vazio. Deixe um pouco de luz na cidade.';

  @override
  String get profileSyncFailed =>
      'Não foi possível atualizar seu status. Tente mais tarde.';

  @override
  String get profileUpdated => 'Atualizado. A cidade sente você respirar.';

  @override
  String get changeAvatar => 'Trocar foto';

  @override
  String get avatarHint =>
      'Toque para trocar a foto · o anel é a cor do seu humor';

  @override
  String get cityName => 'Nome na cidade';

  @override
  String get cityNameHint => 'Opcional, ex.: Gato Andarilho';

  @override
  String get currentMood => 'Seu humor agora';

  @override
  String get currentMoodHint => 'ex.: Caminhando numa chuva fina 🌿';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get blockListTitle => 'Mandados para a escuridão';

  @override
  String get blockListEmpty => 'A noite está limpa. Você não afastou ninguém.';

  @override
  String get unblock => 'Desbloquear';

  @override
  String get deleteAccountBody =>
      'Sua localização, humor, nome na cidade, foto, sussurros, brilhos, lista de bloqueios e conversas abertas serão excluídos para sempre. Não dá para desfazer.\n\nPara evitar abusos, os registros de denúncias são guardados por 1 ano, como descrito na Política de Privacidade.';

  @override
  String get deleting => 'Excluindo…';

  @override
  String get deletePermanently => 'Excluir para sempre';

  @override
  String get deleteFailed =>
      'A exclusão não terminou. Verifique a conexão e tente de novo.';

  @override
  String get fadingEcho => 'Eco se apagando';

  @override
  String clusterCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count humores aqui',
      one: '1 humor aqui',
    );
    return '$_temp0';
  }

  @override
  String clusterMore(int count) {
    return 'Mais\n+$count';
  }

  @override
  String get clusterBackToFirst => 'Voltar ao\ninício';

  @override
  String get fadingEchoTitle => 'Um eco se apagando';

  @override
  String encounterWith(String name) {
    return 'Cruzando caminhos com $name';
  }

  @override
  String get fadingEchoBody =>
      'Isto é só um eco se apagando. Não dá para cruzar caminhos com ele.';

  @override
  String get demoPersonBody =>
      'Esta é uma pessoa de demonstração que responde automaticamente. Não é uma pessoa real. Use para testar batidas, conversa, brilhos, denúncias e bloqueios.';

  @override
  String get sendGlimmer => 'Enviar um brilho';

  @override
  String get knock => 'Bater';

  @override
  String get blockAction => 'Bloquear';

  @override
  String get handOverHost => 'Passar a organização';

  @override
  String get report => 'Denunciar';

  @override
  String get confirmBlockTitle => 'Bloquear esta pessoa?';

  @override
  String confirmBlockBody(String name) {
    return 'Mandar $name para a escuridão?\nDepois do bloqueio, vocês somem da cidade um do outro.';
  }

  @override
  String get confirmBlock => 'Bloquear';

  @override
  String get glimmerReceived =>
      'Alguém te enviou um brilho. Seu humor ressoou com essa pessoa.';

  @override
  String get glimmerSent => 'Você enviou um brilho.';

  @override
  String get glimmerAlreadySent =>
      'Você já enviou um brilho para essa pessoa hoje. Tente amanhã.';

  @override
  String get knockSent => 'Batida enviada. Esperando resposta…';

  @override
  String get knockFailed => 'Sua batida não foi enviada. Tente mais tarde.';

  @override
  String get knockNoAnswer => 'Sem resposta. Sua batida sumiu em silêncio.';

  @override
  String get knockDeclined =>
      'Os caminhos não se cruzaram desta vez. Vamos dar um espaço um ao outro.';

  @override
  String get knockSkipped =>
      'A pessoa deixou para depois, e sua batida sumiu em silêncio.';

  @override
  String get sensingCity => 'Sentindo a cidade…';

  @override
  String get sensingCityHint =>
      'Se sua cidade estiver quieta demais agora, entre no Universo Paralelo ou no Mundo Quântico para conhecer pessoas de outras cidades.';

  @override
  String get gatheringUnavailable =>
      'Os encontros não estão disponíveis agora. Tente mais tarde.';

  @override
  String get notSentCheckNetwork =>
      'Não foi enviado. Verifique a conexão e tente de novo.';

  @override
  String get justNow => 'agora mesmo';

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'há $count minutos',
      one: 'há 1 minuto',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'há $count horas',
      one: 'há 1 hora',
    );
    return '$_temp0';
  }

  @override
  String get nextDayPrefix => 'dia seguinte ';

  @override
  String get gatheringNameMissing => 'Dê um nome ao seu encontro.';

  @override
  String get gatheringEmojiInvalid =>
      'O ícone do encontro precisa ser exatamente um emoji.';

  @override
  String gatheringStarted(String emoji, String name) {
    return '$emoji $name começou. Peça para as pessoas adicionarem $emoji ao nome na cidade para participar.';
  }

  @override
  String get startGatheringTitle => 'Começar um encontro';

  @override
  String get startGatheringLead =>
      'Todos a até 5 km de você. A área acompanha você.';

  @override
  String get gatheringNameHint =>
      'Nome do encontro, ex.: Réveillon em Copacabana';

  @override
  String get gatheringEmojiHint => 'Ícone';

  @override
  String get gatheringEmojiHelp =>
      'O ícone do encontro é um emoji que ninguém por perto está usando.';

  @override
  String gatheringEmojiJoinHelp(String emoji) {
    return 'Quem adicionar $emoji ao nome na cidade verá seus avisos e receberá notificações.';
  }

  @override
  String get start => 'Início';

  @override
  String get end => 'Fim';

  @override
  String get gatheringMaxDuration =>
      'Um encontro dura até 24 horas e termina automaticamente.';

  @override
  String get starting => 'Começando…';

  @override
  String get startGathering => 'Começar encontro';

  @override
  String gatheringEndedYouBack(String emoji, String name) {
    return '$emoji $name terminou. Você voltou para a cidade.';
  }

  @override
  String hostingTimeRange(String range) {
    return '$range · Você está organizando';
  }

  @override
  String hostAudienceRule(String emoji) {
    return 'Pessoas a até 5 km com $emoji no nome veem seus avisos e recebem notificações. Você não vê quem são.';
  }

  @override
  String get postAnnouncement => 'Publicar aviso';

  @override
  String get announcementHint =>
      'ex.: Vamos nos encontrar na esquina da Avenida Paulista';

  @override
  String get announcementSent => 'Aviso enviado';

  @override
  String announcementLine(String ago, String text) {
    return '$ago  $text';
  }

  @override
  String get announcementHiddenSuffix => ' (oculto após muitas denúncias)';

  @override
  String get groupQuestion => 'Perguntar a todos';

  @override
  String get questionHint => 'ex.: Como vocês estão agora?';

  @override
  String get sendQuestion => 'Perguntar';

  @override
  String get questionSent =>
      'Pergunta enviada. Todos vão responder com um humor';

  @override
  String get handOff => 'Passar adiante';

  @override
  String handoffPending(String name) {
    return 'Você convidou $name para assumir a organização. Esperando resposta…';
  }

  @override
  String get theOtherPerson => 'a pessoa';

  @override
  String get handoffCancelled => 'Convite de passagem cancelado';

  @override
  String get handoffHelp =>
      'No radar, toque e segure a bolha de um participante → Passar a organização. Quando a pessoa aceitar, ela organiza e o encontro continua sem interrupção.';

  @override
  String get confirmEndAgain => 'Encerrar? Toque de novo';

  @override
  String get endGathering => 'Encerrar encontro';

  @override
  String tallyHeader(String question, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total respostas',
      one: '1 resposta',
    );
    return '“$question” · $_temp0';
  }

  @override
  String get tallyQuiet =>
      'As porcentagens aparecem depois de 10 respostas, para que ninguém seja identificado quando poucos respondem.';

  @override
  String get bannerYouHost => '  · Você está organizando';

  @override
  String get bannerHostAnnouncement => '  · Do anfitrião';

  @override
  String get manageGathering => 'Gerenciar encontro';

  @override
  String get reportAnnouncement => 'Denunciar este aviso';

  @override
  String get expandAnnouncement => 'Mostrar aviso';

  @override
  String get collapseAnnouncement => 'Ocultar aviso';

  @override
  String hostHandedOffAgo(String ago) {
    return 'Novo anfitrião · $ago';
  }

  @override
  String get announcementReportedHidden =>
      'Você denunciou este aviso, então ele foi removido da sua tela.';

  @override
  String get noAnnouncementHost =>
      'Ainda não há avisos. Toque nos controles no canto superior direito para publicar o primeiro.';

  @override
  String get noAnnouncementGuest => 'O anfitrião ainda não publicou nada.';

  @override
  String hostAsks(String question) {
    return 'O anfitrião pergunta: $question';
  }

  @override
  String get answeredNote =>
      'Respondido. O anfitrião só vê as porcentagens gerais de humor.';

  @override
  String get answerHint => 'Responda com um humor';

  @override
  String get sendAnswer => 'Enviar resposta';

  @override
  String handoffInvited(String name) {
    return 'Você convidou $name para assumir a organização. Esperando resposta (vale por 5 minutos).';
  }

  @override
  String handoffTitle(String name) {
    return 'Passar o encontro para $name';
  }

  @override
  String get handoffBody =>
      'Quando a pessoa aceitar, ela organiza o encontro. O nome, os avisos e a pergunta continuam, e você vira participante.';

  @override
  String get handoffPublic => 'Anunciar a passagem';

  @override
  String get handoffPublicHelp =>
      'Avisar todos os participantes que há um novo anfitrião';

  @override
  String get handoffQuiet => 'Passagem silenciosa';

  @override
  String get handoffQuietHelp =>
      'Ninguém é avisado. Só o anel do anfitrião muda de lugar no radar';

  @override
  String get sending => 'Enviando…';

  @override
  String get sendInvite => 'Enviar convite';

  @override
  String youAreNowHost(String emoji, String name) {
    return 'Agora você organiza $emoji $name.';
  }

  @override
  String get handoffOfferTitle => 'Quer assumir a organização?';

  @override
  String handoffOfferBody(String name) {
    return 'O anfitrião quer passar “$name” para você. Como anfitrião, você pode publicar avisos, fazer perguntas e encerrar o encontro, e é responsável pelo que publicar.';
  }

  @override
  String get processing => 'Processando…';

  @override
  String get acceptHosting => 'Assumir';

  @override
  String get guideS1Title => '1. Entre na cidade';

  @override
  String get guideS1L1 =>
      'Na primeira vez que abrir o app, confirme que tem 18 anos ou mais e permita a localização precisa durante o uso do app. Sem localização precisa, o radar não funciona.';

  @override
  String get guideS1L2 =>
      'Escreva uma frase sobre como você se sente agora (até 20 caracteres), aceite os Termos de Uso e a Política de Privacidade e toque em Fazer check-in aqui e entrar.';

  @override
  String get guideS1L3 =>
      'Não precisa de telefone, e-mail nem nome real. Sua conta é anônima e ligada a este celular.';

  @override
  String get guideS1L4 =>
      'As palavras do seu humor definem a cor: “feliz, rir” é dourado, “triste, chorar” é azul, “bravo” é laranja-avermelhado, “calmo, sonhar” é verde, “animado” é laranja, “amor, coração” é rosa e o resto é violeta suave.';

  @override
  String get guideS1L5 =>
      'Check-in: toda vez que abre o app você faz o check-in sozinho, e só então as pessoas por perto veem seu humor e mais ou menos onde você está, e você as vê. Nunca acontece automaticamente. Os outros veem o lugar do check-in; ele não acompanha você. Se você se afastar mais de 1 km, aparece Fazer check-in aqui embaixo do radar. Se o app ficou em segundo plano por mais de 30 minutos, você faz o check-in de novo ao voltar.';

  @override
  String get guideS2Title => '2. A barra de baixo';

  @override
  String get guideS2L1 =>
      'Toque na sua foto à esquerda para editar a foto, o nome na cidade (até 10 caracteres) e o humor.';

  @override
  String get guideS2L2 =>
      'Ícone de bloco de notas: deixe um sussurro bem aqui.';

  @override
  String get guideS2L3 =>
      'Ícone de compartilhar: transforme seu humor em um cartão noturno.';

  @override
  String get guideS2L4 =>
      'Ícone de controles na ponta direita: abre os Ajustes.';

  @override
  String get guideS3Title => '3. Radar e bolhas';

  @override
  String get guideS3L1 =>
      'As bolhas de humor de pessoas a até 5 km aparecem no radar. Só aparece uma faixa de distância aproximada (como “a menos de 100 m”), nunca um endereço.';

  @override
  String get guideS3L2 =>
      'Só aparece no radar quem fez check-in e está com o app aberto. Quando alguém sai ou troca de app, a bolha some na hora e não deixa rastro.';

  @override
  String get guideS3L3 =>
      'Use dois dedos para dar zoom no mapa. Gire o celular e o radar gira junto.';

  @override
  String get guideS3L4 =>
      'Quando as bolhas se amontoam, elas viram uma esfera brilhante, “N humores aqui”. Toque para abri-las em círculo e tocar em cada uma; toque no meio ou num espaço vazio para fechar.';

  @override
  String get guideS3L5 =>
      'Nomes que começam com Demo são de pessoas de demonstração que respondem automaticamente. Não são reais, e você pode usá-las para testar tudo.';

  @override
  String get guideS3L6 =>
      'Quando não há ninguém por perto, aparece “Você é a primeira luz desta noite” embaixo, e você pode convidar amigos para iluminar seu bairro.';

  @override
  String get guideS4Title => '4. Bater e conversar';

  @override
  String get guideS4L1 =>
      'Toque e segure a bolha de alguém → Bater. A pessoa tem 5 minutos para aceitar, recusar ou pular. Enquanto você espera, uma linha de luz vai de você até ela.';

  @override
  String get guideS4L2 =>
      'Quando a pessoa aceita, começa uma conversa com contagem de 10 minutos. Cada nova mensagem reinicia a contagem, e a conversa termina quando os dois ficam em silêncio.';

  @override
  String get guideS4L3 =>
      'Quando a conversa termina, as mensagens são apagadas do servidor. A outra pessoa ainda pode tirar prints, então compartilhe com cuidado.';

  @override
  String get guideS4L4 =>
      'Quando alguém bate à sua porta, aparece um cartão de batida. Você pode aceitar, recusar, pular ou denunciar na hora.';

  @override
  String get guideS5Title => '5. Brilhos';

  @override
  String get guideS5L1 =>
      'Toque duas vezes na bolha de alguém, ou toque e segure e escolha Enviar um brilho, para mostrar que alguém percebeu, sem dizer nada.';

  @override
  String get guideS5L2 =>
      'A pessoa só vê “N brilhos ressoaram com você esta noite”, nunca quem enviou. Você pode enviar um brilho para a mesma pessoa a cada 24 horas.';

  @override
  String get guideS6Title => '6. Sussurros';

  @override
  String get guideS6L1 =>
      'Toque no ícone de bloco de notas na barra de baixo para deixar uma frase onde você está (até 60 caracteres).';

  @override
  String get guideS6L2 =>
      'Nos próximos 7 dias, quem estiver a até 300 m verá um envelope no radar e poderá abri-lo.';

  @override
  String get guideS6L3 =>
      'Os sussurros são sempre anônimos. Você pode ter até 3 ao mesmo tempo, deixar no máximo 1 a cada 10 minutos e retirá-los quando quiser.';

  @override
  String get guideS6L4 =>
      'Cartas para o futuro: ao escrever um sussurro, escolha Para mim no futuro e depois um mês ou um ano. Só você vê. Quando chegar a hora, você recebe um aviso, e ela abre sozinha quando você voltar a até 100 m. Só pode ser lida uma vez. Só você vê uma pequena ampulheta no radar (trancada ou aberta), e não dá para tocar nela. Você pode ter até 5 ao mesmo tempo; veja ou apague em Ajustes → Minhas cartas para o futuro.';

  @override
  String get guideS7Title => '7. Clima de humor da cidade';

  @override
  String get guideS7L1 =>
      'O rótulo no canto superior esquerdo mostra o humor mais comum a até 20 km nas últimas 24 horas. Toque para ver tudo.';

  @override
  String get guideS7L2 =>
      'As porcentagens ficam ocultas quando menos de 10 pessoas participaram, para que ninguém seja identificado.';

  @override
  String get guideS8Title => '8. Encontros';

  @override
  String get guideS8L1 =>
      'Para começar: Ajustes → Organizar um encontro → escreva um nome, um emoji como ícone e um horário de início e fim (até 24 horas) → Começar encontro.';

  @override
  String get guideS8L2 =>
      'O encontro cobre 5 km ao redor do lugar onde o anfitrião fez check-in; quando ele faz check-in de novo, a área vai junto. O anfitrião tem um anel de luz e o rótulo Anfitrião no radar.';

  @override
  String get guideS8L3 =>
      'O anfitrião pode publicar avisos (quantos quiser), fazer uma pergunta a todos e encerrar o encontro quando quiser.';

  @override
  String get guideS8L4 =>
      'Para participar, adicione o ícone do encontro ao seu nome na cidade (por exemplo “Gato Andarilho🌈”). Enquanto estiver na área, você verá o aviso fixado acima do radar e receberá notificações. Tire o ícone para sair.';

  @override
  String get guideS8L5 =>
      'Pergunta ao grupo: responda com um humor. O anfitrião só vê as porcentagens gerais, nunca quem respondeu o quê, e elas ficam ocultas com menos de 10 respostas.';

  @override
  String get guideS8L6 =>
      'Só um encontro pode usar um ícone na mesma área de cada vez. Quando ele termina, qualquer pessoa pode usar o ícone.';

  @override
  String get guideS8L7 =>
      'Passagem: o anfitrião toca e segura a bolha de um participante → Passar a organização e escolhe passagem anunciada ou silenciosa. Se a pessoa aceitar em 5 minutos, ela vira anfitriã, e os avisos e a pergunta continuam. O anfitrião anterior vira participante e o ícone é adicionado ao nome dele.';

  @override
  String get guideS9Title => '9. Farol da Cidade (banheiros acessíveis)';

  @override
  String get guideS9L1 =>
      'Toque no ícone de banheiro no canto inferior esquerdo do mapa para ligar o farol. Banheiros inclusivos, acessíveis e familiares a até 2 km aparecem no radar, com a contagem ao lado do ícone. Toque nos três filtros redondos acima para mostrar só alguns tipos.';

  @override
  String get guideS9L2 =>
      'Toque em um marcador para ver andar, instalações e distância, e toque em Ir a pé para abrir as rotas no seu app de mapas.';

  @override
  String get guideS9L3 =>
      'Os dados vêm dos registros de banheiros públicos do Ministério do Meio Ambiente de Taiwan e são atualizados todo mês. Horários não estão incluídos; “Provavelmente aberto à noite” é nossa estimativa pelo tipo de lugar.';

  @override
  String get guideS9L4 =>
      'Se algo estiver errado, você pode avisar (não é inclusivo, fechado à noite, não encontrei). Quando 3 pessoas relatam o mesmo problema, o marcador fica cinza com uma nota.';

  @override
  String get guideS10Title => '11. Cartões de humor e trilha de humor';

  @override
  String get guideS10L1 =>
      'O botão de compartilhar na barra de baixo transforma seu humor atual em um cartão noturno, feito para os Stories do Instagram. O cartão nunca mostra sua localização.';

  @override
  String get guideS10L2 =>
      'Ajustes → Minha trilha de humor mostra os humores e lugares que você escreveu. Fica guardada só no seu celular, e você pode desligar ou apagar quando quiser.';

  @override
  String get guideS11Title => '17. Ajustes e notificações';

  @override
  String get guideS11L1 =>
      'Lembrete noturno: um lembrete gentil às 21:30 toda noite. Ligue ou desligue nos Ajustes.';

  @override
  String get guideS11L2 =>
      'Batidas, novas mensagens, brilhos e avisos de encontros chegam como notificações. Você pode desligá-las nos ajustes do celular.';

  @override
  String get guideS11L3 =>
      'Toda sexta das 21:00 às 23:00 é a Noite de Luz, quando todos entram juntos e a cidade brilha mais.';

  @override
  String get guideS12Title => '18. Denúncias e bloqueios';

  @override
  String get guideS12L1 =>
      'Você pode denunciar pelo menu da bolha (toque e segure), pelo cartão de batida, pelo canto superior direito da conversa, por um sussurro ou por um aviso de encontro. Ao denunciar, a pessoa ou publicação some da sua tela na hora e a conversa termina. Tratamos todas as denúncias em até 24 horas.';

  @override
  String get guideS12L2 =>
      'Humores, nomes, sussurros, mensagens e avisos de encontros são filtrados automaticamente contra palavras ofensivas e dados de contato, como telefones e links.';

  @override
  String get guideS12L3 =>
      'Depois de bloquear alguém, vocês somem do radar um do outro e não podem bater nem enviar brilhos. Desbloqueie em Ajustes → Pessoas bloqueadas.';

  @override
  String get guideS12L4 =>
      'Se estiver em perigo imediato, ligue para o número de emergência local (190 no Brasil).';

  @override
  String get guideS13Title => '19. Privacidade e sua conta';

  @override
  String get guideS13L1 =>
      'Só depois do check-in as pessoas por perto veem seu humor, nome na cidade, foto e distância aproximada. Elas veem o lugar do check-in, não sua localização em tempo real.';

  @override
  String get guideS13L2 =>
      'Ajustes → Excluir conta e dados apaga para sempre tudo o que você deixou na cidade, quando quiser.';

  @override
  String get guideS13L3 =>
      'Dúvidas? Vá em Ajustes → Fale conosco ou envie um e-mail para service.softchip@gmail.com.';

  @override
  String get guideS14Title => '12. Universo Paralelo';

  @override
  String get guideS14L1 =>
      'Toque no globo no canto superior direito do radar para ligar, e de novo para desligar. Ele começa desligado toda vez que você abre o app.';

  @override
  String get guideS14L2 =>
      'Cada cidade ou condado de Taiwan tem como centro sua estação central (a Grande Taipé, a Estação de Taipé; Taoyuan, a Estação de Taoyuan; e assim por diante) e é ligada a cidades no exterior: Japão, Coreia, Hong Kong, Macau, Singapura, Malásia, Indonésia, Vietnã, Tailândia, Filipinas, Austrália, Nova Zelândia, Índia, Brasil, Argentina e África do Sul. As cidades no exterior são ligadas a Taiwan.';

  @override
  String get guideS14L3 =>
      'A distância e a direção em que você está da sua estação são onde você aparece na cidade da outra pessoa, na mesma distância e direção da estação dela, borradas em cerca de 500 m. Ninguém vê sua localização real.';

  @override
  String get guideS14L4 =>
      'Vocês se veem se um dos dois estiver com ele ligado: ligado, você vê todos nas cidades ligadas que estão com o app aberto; desligado, você só vê quem o ligou. Só aparecem em outras cidades as pessoas que fizeram check-in e estão com o app aberto.';

  @override
  String get guideS14L5 =>
      'Pessoas do Universo Paralelo têm um anel tracejado e mostram a cidade delas. Você ainda pode enviar brilhos, bater e conversar. Sussurros, cartas para o futuro e encontros ficam no local.';

  @override
  String get guideS15Title => '16. Tradução';

  @override
  String get guideS15L1 =>
      'Numa conversa, quando uma mensagem não está no seu idioma, aparece Toque para traduzir embaixo dela. Toque para traduzir para o seu idioma, e de novo para ver o original.';

  @override
  String get guideS15L2 =>
      'As bolhas de humor no radar funcionam igual: quando uma não está no seu idioma, toque para traduzir e de novo para voltar ao original.';

  @override
  String get guideS15L3 =>
      'A tradução acontece toda no seu celular; o texto nunca é enviado. O iPhone usa a tradução nativa da Apple, e o sistema pergunta antes de baixar um idioma pela primeira vez. O Android usa o Google ML Kit, que pergunta primeiro e depois baixa um modelo de idioma de cerca de 30 MB. O iPhone ainda não traduz malaio.';

  @override
  String get guideIntro =>
      'O Mood Whisper é uma cidade à noite: escreva uma frase sobre como você se sente agora e veja como estão as pessoas perto de você.';

  @override
  String get beaconGender => 'Inclusivo';

  @override
  String get beaconAccessible => 'Acessível';

  @override
  String get beaconFamily => 'Família';

  @override
  String get beaconReportNotGender => 'Não é inclusivo';

  @override
  String get beaconReportClosed => 'Fechado à noite';

  @override
  String get beaconReportMissing => 'Não encontrei este banheiro';

  @override
  String get beaconFlagNotGender => 'Relatado: não é inclusivo';

  @override
  String get beaconFlagClosed => 'Relatado: fechado à noite';

  @override
  String get beaconFlagMissing => 'Relatado: não encontrado';

  @override
  String get beaconDefaultName => 'Banheiro público';

  @override
  String meters(int m) {
    return '$m m';
  }

  @override
  String kilometers(String km) {
    return '$km km';
  }

  @override
  String get beaconUnavailable =>
      'O Farol da Cidade não está disponível agora. Tente mais tarde.';

  @override
  String get notConnectedCheckNetwork =>
      'Sem conexão. Verifique a conexão e tente de novo.';

  @override
  String beaconMarkerLabel(String features, String name, String distance) {
    return 'Banheiro $features, $name, $distance';
  }

  @override
  String get listSeparator => ', ';

  @override
  String beaconToggleOff(int count) {
    return 'Desligar o Farol da Cidade (banheiros acessíveis), $count por perto';
  }

  @override
  String get beaconToggleOn => 'Ligar o Farol da Cidade (banheiros acessíveis)';

  @override
  String beaconFilterOnly(String feature) {
    return 'Mostrar só $feature';
  }

  @override
  String get beaconMaybeOpenNight =>
      'Provavelmente aberto à noite (estimativa)';

  @override
  String get beaconMaybeDaytime => 'Provavelmente só de dia (estimativa)';

  @override
  String get walkThere => 'Ir a pé';

  @override
  String get beaconWrongData => 'Algo errado?';

  @override
  String beaconThanks(String reason) {
    return 'Obrigado. Recebemos seu aviso: “$reason”.';
  }

  @override
  String get beaconSource =>
      'Fonte: registros de banheiros públicos do Ministério do Meio Ambiente de Taiwan, atualizados todo mês. Os horários são nossa estimativa pelo tipo de lugar.';

  @override
  String get invite1 =>
      'Acendi uma luz no Mood Whisper. Quanto mais gente por perto, mais iluminado fica nosso bairro. Vem acender comigo:';

  @override
  String get invite2 =>
      'A cidade está meio quieta hoje. Escreva um humor no Mood Whisper e ajude nosso bairro a brilhar:';

  @override
  String get invite3 =>
      'Sem pedidos de amizade, sem nome real, só uma frase sobre como você está. Me encontre no Mood Whisper:';

  @override
  String get invite4 =>
      'Deixei uma luz acesa para você no Mood Whisper. Abra o app e veja como estão as pessoas por perto esta noite:';

  @override
  String get invite5 =>
      'Toda sexta às 21h é Noite de Luz no Mood Whisper. Entre comigo e vamos encher o radar de luz:';

  @override
  String get invite6 =>
      'Precisa de um lugar para contar como foi o dia? O Mood Whisper é anônimo, e suas palavras somem depois de ditas:';

  @override
  String get invite7 =>
      'Já pensou no que sentem as pessoas por quem você passa na rua? Veja no Mood Whisper:';

  @override
  String get invite8 =>
      'Deixei um sussurro nesta rua que só quem passa pode ler. Venha deixar um também:';

  @override
  String get invite9 =>
      'O Mood Whisper é um mapa dos humores da cidade à noite. Com mais gente fica melhor, então venha acender uma luz no nosso bairro:';

  @override
  String get invite10 =>
      'Qual é a cor do seu humor hoje? Escreva no Mood Whisper. Vou estar por perto, esperando sua luz:';

  @override
  String get shareInvite => 'Compartilhar convite';

  @override
  String get inviteSubject => 'Vem iluminar nosso bairro comigo';

  @override
  String get shareMoodCardButton => 'Compartilhar cartão';

  @override
  String moodShareText(String mood) {
    return 'Compartilhei como estou agora no Mood Whisper: “$mood”\nSeu humor também está brilhando na cidade hoje?';
  }

  @override
  String get shareFailed => 'Não foi compartilhado. Tente de novo.';

  @override
  String shuffleCard(int current, int total) {
    return 'Trocar · $current / $total';
  }

  @override
  String get preparing => 'Preparando…';

  @override
  String get sendLinkToFriends =>
      'Enviar link para amigos (WhatsApp, Messenger)';

  @override
  String get partLateNight => 'Madrugada';

  @override
  String get partMorning => 'Manhã';

  @override
  String get partAfternoon => 'Tarde';

  @override
  String get partDusk => 'Entardecer';

  @override
  String get partNight => 'Noite';

  @override
  String get cardInviteEyebrow => 'Um convite';

  @override
  String get cardMoodEyebrow => 'Como me sinto agora';

  @override
  String get cardInviteTitle => 'Vem iluminar\nnosso bairro';

  @override
  String get cardInviteBody =>
      'Acendi uma luz no Mood Whisper.\nQuanto mais gente por perto, mais brilha nosso bairro.';

  @override
  String cardMoodFooter(String date, String partOfDay) {
    return '$date · $partOfDay\nEm algum lugar da cidade';
  }

  @override
  String get whisperUnavailable =>
      'Os sussurros não estão disponíveis agora. Tente mais tarde.';

  @override
  String get whisperNotSent =>
      'Seu sussurro não foi enviado. Verifique a conexão e tente de novo.';

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'há $count dias',
      one: 'há 1 dia',
    );
    return '$_temp0';
  }

  @override
  String get timeWhisperTitle => 'Carta para o futuro';

  @override
  String get timeWhisperLead =>
      'Escreva para você no futuro. Quando chegar a hora, volte aqui para abrir.';

  @override
  String get whisperLead => 'Escreva para a próxima pessoa que passar.';

  @override
  String get toPassersBy => 'Para quem passar';

  @override
  String get toFutureSelf => 'Para mim no futuro';

  @override
  String get inOneMonth => 'Em um mês';

  @override
  String get inOneYear => 'Em um ano';

  @override
  String get timeWhisperHint =>
      'ex.: Até ano que vem aqui. Espero que você esteja melhor do que agora.';

  @override
  String get whisperHint =>
      'ex.: O pôr do sol aqui é lindo. Lembre de olhar para cima.';

  @override
  String get timeWhisperCaptionYear =>
      'Só você vê · abre em um ano e avisa você · abre a até 100 m';

  @override
  String get timeWhisperCaptionMonth =>
      'Só você vê · abre em um mês e avisa você · abre a até 100 m';

  @override
  String get whisperCaption =>
      'Some em 7 dias · nunca mostra quem você é · só que você esteve por aqui';

  @override
  String get sealHere => 'Selar aqui';

  @override
  String get leaveHere => 'Deixar aqui';

  @override
  String get aWhisper => 'Um sussurro';

  @override
  String whisperLeftAgo(String ago) {
    return 'Deixado por aqui $ago';
  }

  @override
  String whisperCollectedBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lido por $count pessoas',
      one: 'Lido por 1 pessoa',
    );
    return '$_temp0';
  }

  @override
  String get whisperNobodyYet => 'Ninguém passou por aqui ainda';

  @override
  String get withdrawWhisper => 'Retirar este sussurro';

  @override
  String get whisperCollected => 'Você pegou este sussurro.';

  @override
  String whisperReadersBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pessoas passaram antes de você.',
      one: '1 pessoa passou antes de você.',
    );
    return '$_temp0';
  }

  @override
  String get whisperFirstReader => 'Você é a primeira pessoa a passar.';

  @override
  String get reportWhisper => 'Denunciar este sussurro';

  @override
  String get thisWhisper => 'Este sussurro';

  @override
  String get chatTimeUp => 'O tempo acabou. O instante se apaga...';

  @override
  String get chatOtherLeft => 'A pessoa voltou para a cidade...';

  @override
  String get chatEnded => 'Este instante terminou...';

  @override
  String get chatBlockedEnded => 'Bloqueado. A conversa terminou.';

  @override
  String get chatReportedEnded => 'Denunciado. A conversa terminou.';

  @override
  String get anonymous => 'Anônimo';

  @override
  String get leaveChat => 'Sair da conversa';

  @override
  String chatWith(String name) {
    return 'Um instante com $name';
  }

  @override
  String get countdownPrefix => 'Some em ';

  @override
  String get countdownSuffix => '';

  @override
  String get demoChatNotice =>
      'Conversa de demonstração: as respostas são automáticas, não de uma pessoa real.';

  @override
  String get typing => 'Digitando…';

  @override
  String get chatHint => 'Diga algo baixinho…';

  @override
  String get send => 'Enviar';

  @override
  String get chatDissolvedApart => 'Cada um voltou para a cidade';

  @override
  String get knockTooOften =>
      'Você está batendo demais. Respire com a cidade...';

  @override
  String get otherNotNow =>
      'A pessoa prefere não ser incomodada agora. Deem um espaço um ao outro.';

  @override
  String otherNotNowMinutes(int minutes) {
    return 'A pessoa prefere não ser incomodada agora. Deem um espaço um ao outro ($minutes min).';
  }

  @override
  String get justEndedRest =>
      'Vocês acabaram de se despedir. Deixe a lembrança assentar um pouco.';

  @override
  String get intro1Title => 'Entre na cidade';

  @override
  String get intro1Body =>
      'Deixe os rótulos sociais para trás. Numa tela escura e silenciosa, só resta como você realmente se sente, e onde.';

  @override
  String get intro2Title => 'Um instante passageiro';

  @override
  String get intro2Body =>
      'Viu uma bolha de humor flutuando por perto? Bata de leve e tenha uma conversa única com alguém que está passando.';

  @override
  String get intro3Title => 'O ritmo da cidade';

  @override
  String get intro3Body =>
      'Nos importamos com o que você sente. Depois de bater, espere a resposta em silêncio. Se não for para ser, a bolha some depois de 300 segundos.';

  @override
  String get intro4Title => 'Uma distância gentil';

  @override
  String get intro4Body =>
      'Não quer ser incomodado? Recuse ou bloqueie. Um sistema de pausa afasta o barulho e devolve seu cantinho tranquilo.';

  @override
  String get intro5Title => 'Pronto para encontrar?';

  @override
  String get intro5Body =>
      'Feche os olhos e sinta o pulso do celular e o seu coração. Agora escreva como você se sente, faça check-in aqui e entre no Mood Whisper.';

  @override
  String get intro6Title => 'Uma carta para você no futuro';

  @override
  String get intro6Body =>
      'Deixe algumas palavras neste lugar para você daqui a um mês ou um ano. Ela só abre quando você voltar.';

  @override
  String get intro7Title => 'Brilhem juntos esta noite';

  @override
  String get intro7Body =>
      'Organize um encontro com um emoji como senha secreta. Todos que o adicionarem ao nome recebem seus avisos, e o bairro inteiro se ilumina junto.';

  @override
  String get intro8Title => 'Universo Paralelo';

  @override
  String get intro8Body =>
      'Toque no globo e as cidades de Taiwan se sobrepõem a Tóquio, Seul, São Paulo e Buenos Aires. Veja como pessoas distantes se sentem agora, bata, converse e toque para traduzir.';

  @override
  String get loadingImage => 'Carregando imagem...';

  @override
  String get startExploring => 'Começar a explorar';

  @override
  String get nextPage => 'Próximo';

  @override
  String get feedbackSubject => 'Feedback do Mood Whisper';

  @override
  String get loginNeedMood =>
      'Escreva como você se sente agora e entre na cidade.';

  @override
  String get loginNeedAgree =>
      'Leia e aceite os Termos de Uso e a Política de Privacidade primeiro.';

  @override
  String get loginCantConnect =>
      'Não conseguimos chegar à cidade. Verifique a conexão e tente de novo.';

  @override
  String get ageQuestion => 'Você tem 18 anos ou mais?';

  @override
  String get ageReason =>
      'O Mood Whisper conecta você a desconhecidos por perto, então é só para maiores de 18 anos.';

  @override
  String get ageUnder => 'Tenho menos de 18';

  @override
  String get ageOver => 'Tenho 18 ou mais';

  @override
  String get loginTitle1 => 'Pronto';

  @override
  String get loginTitle2 => ' para encontrar?';

  @override
  String get loginLead =>
      'Feche os olhos e sinta o pulso do celular e o seu coração.\nAgora escreva como você se sente e entre no Mood Whisper.';

  @override
  String get loginPrompt => 'O que você quer dizer à cidade agora?';

  @override
  String get loginHint => 'ex.: Tomei um café muito bom😊';

  @override
  String get enterCity => 'Entrar no Mood Whisper';

  @override
  String get agreeSemantic =>
      'Li e aceito os Termos de Uso e a Política de Privacidade';

  @override
  String get agreePrefix => 'Li e aceito os ';

  @override
  String get termsLink => 'Termos de Uso';

  @override
  String get agreeAnd => ' e a ';

  @override
  String get privacyLink => 'Política de Privacidade';

  @override
  String get agreeSuffix =>
      '. O Mood Whisper tem tolerância zero com assédio, conteúdo sexual, ódio ou outros abusos. Quem desrespeitar essa regra será removido.';

  @override
  String get under18Title => 'O Mood Whisper é para maiores de 18 anos';

  @override
  String get under18Body =>
      'Obrigado pela sinceridade. Esta cidade conecta você a desconhecidos. Até quando você fizer 18.';

  @override
  String get clearMoodTrail => 'Apagar trilha de humor';

  @override
  String get clearMoodTrailBody =>
      'Toda a trilha de humor deste celular será apagada. Não dá para desfazer.';

  @override
  String get clear => 'Apagar';

  @override
  String monthDay(int month, int day) {
    return '$day/$month';
  }

  @override
  String get moodTrailLocalOnly =>
      'Guardada só no seu celular. Nunca é enviada.';

  @override
  String get moodTrailEmpty =>
      'Ainda não há trilha de humor nesta semana. Cada vez que você escreve um humor ou vai a um lugar novo, uma nova luz aparece aqui.';

  @override
  String get thisWeekYou => 'Sua semana';

  @override
  String get topMoodPrefix => 'O que você mais sentiu foi “';

  @override
  String topMoodSuffix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '”, $count vezes',
      one: '”, 1 vez',
    );
    return '$_temp0';
  }

  @override
  String weekPlacesMoods(int places, int total) {
    return '$total humores deixados em $places lugares diferentes';
  }

  @override
  String get recordMoodTrail => 'Registrar minha trilha de humor';

  @override
  String get recordMoodTrailOff =>
      'Desligado, nenhuma nova trilha é registrada';

  @override
  String get nightly1 => 'O que a cidade está sentindo esta noite?';

  @override
  String get nightly2 =>
      'Alguém por perto está escrevendo como se sente agora.';

  @override
  String get nightly3 =>
      'A noite está perfeita. Deixe uma frase para a cidade.';

  @override
  String get nightly4 => 'Como foi hoje? Seu humor vai brilhar na cidade.';

  @override
  String get nightly5 =>
      'As luzes da rua acenderam, e as pessoas por perto ainda estão acordadas.';

  @override
  String get nightly6 => 'Dê um fim ao dia: como você se sente agora?';

  @override
  String get nightly7 => 'Por quem você vai passar esta noite?';

  @override
  String get nightlyChannel => 'Lembrete noturno';

  @override
  String get nightlyChannelDesc =>
      'Um lembrete gentil toda noite. Você pode desligar nos ajustes do app.';

  @override
  String get reasonHarassment => 'Assédio ou bullying';

  @override
  String get reasonSexual => 'Conteúdo sexual';

  @override
  String get reasonScam => 'Golpe ou spam';

  @override
  String get reasonHate => 'Ódio ou violência';

  @override
  String get reasonImpersonation => 'Falsidade ideológica';

  @override
  String get reasonOther => 'Outro motivo';

  @override
  String get reportReceived =>
      'Denúncia recebida e removida da sua tela. Vamos analisar em até 24 horas.';

  @override
  String get reportNotSent =>
      'Sua denúncia não foi enviada. Verifique a conexão e tente de novo.';

  @override
  String reportTarget(String target) {
    return 'Denunciar $target';
  }

  @override
  String get reportPrivate =>
      'A pessoa não vai saber que você denunciou. Escolha um motivo:';

  @override
  String get reportDetails => 'Mais detalhes (opcional)';

  @override
  String get reportWhatHappened => 'O que aconteceu?';

  @override
  String get sendReport => 'Enviar denúncia';

  @override
  String get alsoBlock => 'Bloquear também. Vocês somem da cidade um do outro.';

  @override
  String get aYearAgo => 'Há um ano';

  @override
  String get aMonthAgo => 'Há um mês';

  @override
  String get timeWhisperUnavailable =>
      'As cartas para o futuro não estão disponíveis agora. Tente mais tarde.';

  @override
  String timeWhisperYouSaid(String ago) {
    return '$ago, você disse aqui';
  }

  @override
  String writtenOn(String date) {
    return 'Escrita em $date';
  }

  @override
  String get timeWhisperOnce => 'Esta carta aparece só uma vez.';

  @override
  String get keepInHeart => 'Guardar no coração';

  @override
  String unsealsOn(String unlock, String created) {
    return 'Abre em $unlock · escrita em $created';
  }

  @override
  String get unsealedGoBack => 'Liberada. Volte lá para abrir.';

  @override
  String unsealedDistance(String distance) {
    return 'Liberada · a $distance';
  }

  @override
  String get timeWhisperListLead =>
      'Cartas para você no futuro que só você vê. Quando chegar a hora, chegue a até 100 m do lugar para abrir. Depois de lida, ela some.';

  @override
  String get timeWhisperListEmpty =>
      'Ainda não há cartas para o futuro. Toque no ícone de recado na barra de baixo e escolha “Para mim no futuro”.';

  @override
  String get readyToOpen => 'Pronta para abrir';

  @override
  String get sealed => 'Selada';

  @override
  String get delete => 'Excluir';

  @override
  String get within100m => 'A até 100 m';

  @override
  String knockWaitingSemantic(String name, String mm, String ss) {
    return 'Esperando $name responder, faltam $mm:$ss';
  }

  @override
  String knockWaiting(String name) {
    return 'Esperando $name';
  }

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Igual ao celular';

  @override
  String get parallelUniverse => 'Universo Paralelo';

  @override
  String get parallelUniverseSubtitle =>
      'Veja como outras cidades se sentem agora e deixe que elas vejam você';

  @override
  String get parallelUniverseIntroTitle => 'Entre no Universo Paralelo';

  @override
  String get parallelUniverseIntroBody =>
      'Quando ligado, todos com o app aberto nas cidades ligadas à sua aparecem no seu radar, e todos podem ver você. As cidades de Taiwan são ligadas a cidades no exterior (como Tóquio, Seul e São Paulo), e as cidades no exterior são ligadas a Taiwan.\n\nAs duas cidades se alinham pelo centro (a estação central, ou a prefeitura onde não há estação): a distância e a direção em que você está do seu centro são onde você aparece na outra cidade, borradas em cerca de 500 m, então ninguém vê sua localização ou distância real. Você ainda pode enviar brilhos, bater e conversar, e desligar quando quiser. Sussurros e encontros ficam no local.';

  @override
  String get parallelUniverseEnter => 'Entrar';

  @override
  String get parallelUniverseNoCity =>
      'Ainda não há Universo Paralelo onde você está';

  @override
  String parallelFrom(String city) {
    return 'Paralelo · $city';
  }

  @override
  String parallelPersonBody(String city) {
    return 'Esta pessoa está em $city, não perto de você. A posição é projetada e não mostra uma distância real.';
  }

  @override
  String get labelHost => 'Anfitrião';

  @override
  String get labelDemo => 'Demo';

  @override
  String get labelResting => 'Descansando';

  @override
  String get cityTaipei => 'Taipé';

  @override
  String get cityTaichung => 'Taichung';

  @override
  String get cityKaohsiung => 'Kaohsiung';

  @override
  String get cityTokyo => 'Tóquio';

  @override
  String get cityOsaka => 'Osaka';

  @override
  String get citySeoul => 'Seul';

  @override
  String get cityBusan => 'Busan';

  @override
  String get cityHongkong => 'Hong Kong';

  @override
  String get cityMacau => 'Macau';

  @override
  String get citySingapore => 'Singapura';

  @override
  String get cityKualalumpur => 'Kuala Lumpur';

  @override
  String get cityJakarta => 'Jacarta';

  @override
  String get cityHochiminh => 'Cidade de Ho Chi Minh';

  @override
  String get cityHanoi => 'Hanói';

  @override
  String get translateTap => 'Toque para traduzir';

  @override
  String get translateShowOriginal => 'Traduzido · toque para ver o original';

  @override
  String get translating => 'Traduzindo…';

  @override
  String get translateFailed => 'Não foi possível traduzir. Tente mais tarde.';

  @override
  String get translateDownloadTitle => 'Baixar modelo de tradução';

  @override
  String get translateDownloadBody =>
      'Para traduzir este idioma pela primeira vez, é preciso um modelo de tradução (cerca de 30 MB por idioma, baixado uma vez).\n\nA tradução acontece toda no seu celular; as mensagens nunca são enviadas.';

  @override
  String get translateDownload => 'Baixar';

  @override
  String placeHint(String name) {
    return 'Há uma luz de Lugar de Humor por perto · $name';
  }

  @override
  String placeOpenUntil(String time) {
    return 'Aberto até $time';
  }

  @override
  String placeLampLabel(String name, String hours) {
    return 'Lugar de Humor: $name, $hours';
  }

  @override
  String get placeWrongData => 'Algo errado?';

  @override
  String placeReportSubject(String name) {
    return 'Informação do Lugar de Humor errada: $name';
  }

  @override
  String get placeHintsSetting => 'Avisos de Lugares de Humor';

  @override
  String get placeHintsSettingSubtitle =>
      'Um aviso discreto no app quando você passa por um Lugar de Humor aberto (sem notificações push)';

  @override
  String get guideS16Title => '10. Lugares de Humor';

  @override
  String get guideS16L1 =>
      'Lugares de Humor são cafés independentes parceiros. Depois do check-in, chegue a até 150 m de um enquanto estiver aberto e uma pequena luz aparece no seu radar, respirando devagar. Ela apaga quando você se afasta.';

  @override
  String get guideS16L2 =>
      'Toque na luz para abrir o cartão do lugar: uma vista noturna de dentro, o horário de fechamento de hoje, uma história de humor do café em uma linha (toque para traduzir), o endereço e o telefone. Toque em Ir a pé para ver a rota no seu app de mapas. A luz cujo cartão você abriu hoje brilha suave, sem respirar.';

  @override
  String get guideS16L3 =>
      'Na primeira vez que você passa, um pequeno cartão no topo avisa, sem som nem vibração. Você recebe no máximo um aviso por lugar a cada 7 dias e 2 avisos por dia. Desligue em Ajustes > Avisos de Lugares de Humor; as luzes continuam.';

  @override
  String get guideS16L4 =>
      'A lista inteira de lugares é baixada no seu celular, e se você está perto é calculado só no celular. Nem nós nem os cafés sabemos por onde você passa. Os cafés não podem pagar por visibilidade. Se algo estiver errado, avise no fim do cartão.';

  @override
  String get placeGuestbook => 'Livro de recados';

  @override
  String placeGuestbookLocked(int m) {
    return 'Entre no local (a até uns $m m) para ler o que deixaram as pessoas que sentaram aqui antes.';
  }

  @override
  String get placeGuestbookAbout =>
      'Só quem está dentro pode ler. Anônimo, some em 30 dias.';

  @override
  String get placeGuestbookEmpty => 'Ainda não há recados. Deixe o primeiro.';

  @override
  String get placeGuestbookWrite => 'Deixar um recado';

  @override
  String get placeGuestbookHint => 'Para a próxima pessoa que sentar aqui…';

  @override
  String get placeGuestbookSent => 'Pronto. A próxima pessoa aqui vai ler.';

  @override
  String get placeGuestbookUnavailable =>
      'O livro de recados não está disponível agora. Tente mais tarde.';

  @override
  String get placeNoteMine => 'Seu recado';

  @override
  String get withdrawPlaceNote => 'Retirar este recado';

  @override
  String get reportPlaceNote => 'Denunciar este recado';

  @override
  String get thisPlaceNote => 'este recado';

  @override
  String get guideS16L5 =>
      'Livro de recados: abra o cartão de um lugar enquanto estiver dentro (a até uns 40 m) para ler o que deixaram as pessoas que sentaram ali antes e deixar uma linha para a próxima. Os recados são anônimos e somem em 30 dias. Você pode deixar um recado por lugar por dia, tocar em um recado para traduzir e denunciar o que incomodar. Ao abrir o livro, seu celular envia sua localização ao nosso servidor para confirmar que você está dentro; o servidor não a guarda.';

  @override
  String get quantumWorld => 'Mundo Quântico';

  @override
  String get quantumWorldSubtitle =>
      'Uma sala para o mundo todo, sem revelar onde você está';

  @override
  String get quantumIntroTitle => 'Entre no Mundo Quântico';

  @override
  String get quantumIntroBody =>
      'Todos que estão no Mundo Quântico agora dividem uma sala, organizada como uma colmeia ao redor do Taipei 101. Você recebe um assento como \"Q4-17\" — quanto menor o anel, mais perto da origem.\n\nNinguém vê sua localização real. Os outros veem só seu assento, fixado no momento em que você toca em Entrar; ele não se move quando você anda. Para mudar, saia e entre de novo. Seu apelido e humor continuam os mesmos, e você ainda pode enviar brilhos, bater e conversar, com tradução ao toque.\n\nEnquanto estiver no Mundo Quântico, você sai temporariamente do radar normal e do Universo Paralelo; ao sair, volta ao lugar do check-in.';

  @override
  String get quantumEnter => 'Entrar';

  @override
  String get quantumLeave => 'Sair do Mundo Quântico';

  @override
  String get quantumLeft => 'Você saiu do Mundo Quântico e voltou ao seu radar';

  @override
  String quantumYourSeat(String code) {
    return 'Seu assento $code';
  }

  @override
  String quantumSeatHint(int ring) {
    return 'Anel $ring · anéis menores ficam mais perto da origem no Taipei 101';
  }

  @override
  String quantumOnlineChip(int count) {
    return '$count aqui agora';
  }

  @override
  String quantumOnlineTitle(int count) {
    return '$count pessoas no Mundo Quântico agora';
  }

  @override
  String get quantumRegionTw => 'Taiwan';

  @override
  String get quantumRegionJp => 'Japão';

  @override
  String get quantumRegionKr => 'Coreia';

  @override
  String get quantumRegionHkmo => 'Hong Kong e Macau';

  @override
  String get quantumRegionSea => 'Sudeste Asiático';

  @override
  String get quantumRegionOther => 'Outros lugares';

  @override
  String get quantumQuiet => 'Silêncio Quântico';

  @override
  String get quantumQuietSubtitle =>
      'Só observe o mundo: ninguém pode bater, mas os brilhos ainda chegam';

  @override
  String get quantumQuietTarget =>
      'A pessoa ligou o Silêncio Quântico — agora você só pode enviar um brilho';

  @override
  String get quantumClosedRegion =>
      'O Mundo Quântico não está disponível onde você está';

  @override
  String get quantumLeftClosed =>
      'Você entrou numa área onde o Mundo Quântico não está disponível, então saiu dele';

  @override
  String get quantumSeatExpired =>
      'Você ficou fora tempo demais e seu assento foi liberado; você voltou ao seu radar';

  @override
  String get quantumUnavailable =>
      'Não foi possível chegar ao Mundo Quântico agora. Tente mais tarde.';

  @override
  String quantumPersonBody(String code) {
    return 'O assento desta pessoa no Mundo Quântico é $code. No Mundo Quântico ninguém mostra a localização real.';
  }

  @override
  String quantumChatTag(String code) {
    return 'Mundo Quântico · $code';
  }

  @override
  String get guideS17Title => '13. Mundo Quântico';

  @override
  String get guideS17L1 =>
      'Toque no ícone de colmeia no canto superior direito do radar (abaixo do Universo Paralelo), leia a nota e toque em Entrar. Você entra tocando toda vez, como num check-in; toda vez que abre o app, começa no radar normal.';

  @override
  String get guideS17L2 =>
      'Todos no Mundo Quântico dividem uma sala: uma colmeia ao redor do Taipei 101, com assentos a 100 m um do outro. Você recebe um código como \"Q4-17\" (anel 4, assento 17) — anéis menores ficam mais perto da origem. Quem chega ocupa primeiro os assentos deixados por outros; os anéis 1–3 são reservados para anfitriões de encontros.';

  @override
  String get guideS17L3 =>
      'Ninguém vê sua localização real: os outros só veem seu assento. Cada toque em Entrar conta como um check-in, e seu assento fica fixo a partir desse momento; ele não se move quando você anda. Para mudar, saia e entre de novo. O Mundo Quântico não está disponível na China continental.';

  @override
  String get guideS17L4 =>
      'Seu apelido e humor continuam os mesmos, e você ainda pode enviar brilhos, bater e conversar, com tradução ao toque. Afaste os dedos para ver a colmeia inteira; pessoas distantes viram pontos de luz. Toque no código do seu assento no canto superior esquerdo para ver quem está online, ligar o Silêncio Quântico (sem batidas, os brilhos ainda chegam) ou sair.';

  @override
  String get guideS17L5 =>
      'Não há sussurros, cartas para o futuro, Lugares de Humor, Farol da Cidade nem encontros comuns no Mundo Quântico. Enquanto estiver lá, você sai temporariamente do radar normal e do Universo Paralelo; ao sair, sua bolha se desfaz em luz e você volta ao lugar do check-in. Se o app ficar fechado ou offline por mais de 3 minutos, seu assento é liberado.';

  @override
  String quantumChimeCountdown(int seconds) {
    return 'Badalada da hora em ${seconds}s';
  }

  @override
  String get quantumChimeLookOrigin =>
      'Todos estão olhando para a origem no 101';

  @override
  String get quantumChimeLook => 'Ver';

  @override
  String quantumChimeNow(int hour) {
    return 'Badalada das $hour no Centro Quântico';
  }

  @override
  String get quantumChimeSend => 'Enviar um brilho da badalada';

  @override
  String get quantumChimeSent => 'Seu brilho está voando até a origem';

  @override
  String quantumChimeWatched(int n) {
    return '$n pessoas assistiram juntas a esta badalada';
  }

  @override
  String get quantumChimeReminder => 'Lembrete da badalada';

  @override
  String get quantumChimeReminderSubtitle =>
      'Um aviso pouco antes de cada hora para ver a badalada na origem do 101';

  @override
  String get quantumChimeNotifyBody =>
      'A badalada da hora vai começar — venha assistir na origem do 101';

  @override
  String get quantumChimeChannel => 'Badalada da hora';

  @override
  String get quantumChimeChannelDesc =>
      'Lembretes da badalada de cada hora no Mundo Quântico';

  @override
  String get quantumEntangleInvite => 'Convidar para entrelaçar';

  @override
  String quantumEntangleInvited(String name) {
    return 'Você convidou $name para entrelaçar';
  }

  @override
  String get quantumEntangleAskTitle => 'Entrelaçamento quântico';

  @override
  String quantumEntangleAskBody(String name, String code) {
    return '$name ($code) quer se entrelaçar com você. Uma linha fina de luz vai unir suas bolhas, visível por mais longe que estejam. Ela colapsa quando um de vocês sai, e nada é guardado.';
  }

  @override
  String get quantumEntangleAccept => 'Entrelaçar';

  @override
  String quantumEntangled(String name) {
    return 'Você e $name estão entrelaçados';
  }

  @override
  String quantumEntangleCollapsed(String name) {
    return 'Seu entrelaçamento com $name colapsou';
  }

  @override
  String get quantumEntangleCut => 'Desentrelaçar';

  @override
  String get quantumEntangleFull => 'Você já está entrelaçado com 3 pessoas';

  @override
  String get quantumEntangleTheirFull =>
      'A pessoa já está entrelaçada com 3 pessoas';

  @override
  String get quantumEntangleGone => 'A pessoa saiu do Mundo Quântico';

  @override
  String get quantumEntangleExpired => 'O convite expirou';

  @override
  String get quantumEntangledTitle => 'Entrelaçados';

  @override
  String get quantumTunnel => 'Tunelamento quântico';

  @override
  String get quantumTunnelSubtitle =>
      'Pule para um assento vazio aleatório da colmeia e conheça novos vizinhos. Uma vez por visita.';

  @override
  String get quantumTunnelUsed => 'Você já usou o tunelamento nesta visita';

  @override
  String quantumTunnelDone(String code) {
    return 'Tunelado para $code';
  }

  @override
  String get quantumShowTime => 'Mostrar minha hora local';

  @override
  String get quantumShowTimeSubtitle =>
      'Os outros veem ao tocar e segurar sua bolha. Desligado, só aparece a cor de dia ou noite.';

  @override
  String quantumLocalTime(String time, String part) {
    return 'Local $time · $part';
  }

  @override
  String get quantumDawn => 'madrugada';

  @override
  String get quantumDay => 'dia';

  @override
  String get quantumDusk => 'entardecer';

  @override
  String get quantumNight => 'noite alta';

  @override
  String get quantumTopicsTitle => 'Sintonia quântica';

  @override
  String get quantumTopicsSubtitle =>
      'Escolha até 3 temas para mostrar embaixo da sua bolha';

  @override
  String get quantumTopicMusic => 'Música';

  @override
  String get quantumTopicMovies => 'Filmes';

  @override
  String get quantumTopicTech => 'Tecnologia';

  @override
  String get quantumTopicWalks => 'Caminhadas';

  @override
  String get quantumTopicFood => 'Comida';

  @override
  String get quantumTopicTravel => 'Viagens';

  @override
  String get quantumTopicReading => 'Leitura';

  @override
  String get quantumTopicSports => 'Esportes';

  @override
  String quantumTopicsCommon(String topics) {
    return 'Vocês dois curtem: $topics';
  }

  @override
  String get quantumSignalsTitle => 'Sinais quânticos';

  @override
  String quantumSignalReceived(String name) {
    return '$name te enviou um sinal';
  }

  @override
  String get quantumSignalWait =>
      'Você acabou de enviar um — tente daqui a pouco';

  @override
  String quantumResonance(String name) {
    return 'Você e $name estão em ressonância';
  }

  @override
  String get guideS17L6 =>
      'Badalada da hora: um minuto antes de cada hora, o feixe do 101 fica mais forte. Na hora cheia, mensageiros de luz circulam a origem, o sino toca a hora do Centro Quântico (24 badaladas à meia-noite) e uma última onda de luz atravessa a colmeia. Toque em “Enviar um brilho da badalada” durante a badalada — quanto mais gente assistindo, mais forte a luz. O lembrete da badalada vem ligado; você pode desligar no painel.';

  @override
  String get guideS17L7 =>
      'Depois de conversar, você pode convidar alguém para entrelaçar: uma linha de luz une suas bolhas por mais longe que estejam e colapsa quando um de vocês sai (até 3 ao mesmo tempo). O tunelamento quântico, uma vez por visita, leva você a um assento vazio aleatório com novos vizinhos.';

  @override
  String get guideS17L8 =>
      'Cada bolha leva a cor da hora local de quem a usa: dourado claro de madrugada, branco brilhante de dia, laranja-violeta ao entardecer, azul profundo à noite. Ligue “Mostrar minha hora local” para que os outros vejam a hora ao tocar e segurar sua bolha. Trocar brilhos em 24 horas cria ressonância; toque e segure uma bolha para enviar um sinal 👋 ☕ 🌙 🎵 🌧️ ✨; escolha até 3 temas de sintonia no painel e os que vocês têm em comum acendem.';

  @override
  String get quantumNyTitle => 'Ano Novo Quântico';

  @override
  String quantumNyDays(int n) {
    return 'Faltam $n dias: à meia-noite do Centro Quântico em 31/12, faça a contagem regressiva com o mundo na origem do 101';
  }

  @override
  String get quantumNyTonight =>
      'Hoje à meia-noite do Centro Quântico, faça a contagem regressiva com o mundo na origem do 101';

  @override
  String quantumNyZone(String places) {
    return 'Feliz Ano Novo, $places 🎆';
  }

  @override
  String quantumNyTogether(int n) {
    return '$n pessoas pelo mundo receberam o ano novo juntas no Mundo Quântico';
  }

  @override
  String get quantumNyHappy => 'Feliz Ano Novo';

  @override
  String get guideS17L9 =>
      'Ano Novo Quântico: em 31/12, quando cada fuso horário chega à meia-noite, suas bolhas acendem anéis dourados em ondas, e os pontos da visão do mundo também ficam dourados. À meia-noite do Centro Quântico, a colmeia inteira conta os últimos 10 segundos, a origem do 101 solta a maior explosão de luz do mundo e 5 minutos de fogos, e você vê quantas pessoas entraram juntas no ano novo.';

  @override
  String get quantumMeetAction => 'Fazer um cartão de Encontro Quântico';

  @override
  String quantumMeetAsked(String name) {
    return 'Você chamou $name para fazer um cartão de Encontro Quântico juntos';
  }

  @override
  String get quantumMeetWait => 'Você acabou de pedir — tente daqui a pouco';

  @override
  String get quantumMeetAskTitle => 'Cartão de Encontro Quântico';

  @override
  String quantumMeetAskBody(String name, String code) {
    return '$name (⬡ $code) quer transformar este encontro num cartão para compartilhar. Ele mostra os apelidos, códigos de assento, horas locais e humores de vocês dois — nunca uma localização.';
  }

  @override
  String get quantumMeetAccept => 'Fazer juntos';

  @override
  String get quantumMeetEyebrow => 'ENCONTRO QUÂNTICO';

  @override
  String get quantumMeetFooter => 'Nos conhecemos no Mundo Quântico';

  @override
  String get quantumMeetShare => 'Compartilhar cartão';

  @override
  String quantumMeetShareText(String a, String b) {
    return '$a × $b — nos conhecemos no Mundo Quântico ✨';
  }

  @override
  String get guideS17L10 =>
      'Cartão de Encontro Quântico: depois de conversar, toque e segure a bolha da pessoa para convidá-la a fazer um juntos. Quando os dois aceitam, cada um recebe um cartão para compartilhar com os dois apelidos, códigos de assento, horas locais com a cor de dia ou noite e humores — nunca uma localização. Códigos de assento do anel 4 brilham em dourado.';

  @override
  String get quantumOrbEntry => 'Avatar quântico';

  @override
  String get quantumOrbEntrySubtitle =>
      'Sua foto vira uma esfera de cristal no Mundo Quântico';

  @override
  String get orbTitle => 'Avatar quântico';

  @override
  String get orbSubtitle => 'O vidro e o brilho sempre seguem seu humor';

  @override
  String get orbStyleGlow => 'Brilho';

  @override
  String get orbStyleRing => 'Anel';

  @override
  String get orbStyleRainbow => 'Arco-íris';

  @override
  String get orbFree => 'Grátis';

  @override
  String get orbOwned => 'Seu';

  @override
  String get orbInUse => 'Em uso';

  @override
  String get orbCosmeticNote =>
      'As esferas especiais são só um visual — não mudam nenhum recurso ou privilégio. As esferas compradas ficam na sua conta.';

  @override
  String get orbRestore => 'Restaurar compras';

  @override
  String orbPurchased(String name) {
    return '$name é seu ✨';
  }

  @override
  String get orbPurchaseFailed =>
      'A compra não foi concluída. Tente mais tarde.';

  @override
  String get orbOwnedElsewhere => 'Esta compra já foi usada em outra conta';

  @override
  String get orbStoreUnavailable =>
      'Não foi possível acessar a loja agora. Tente mais tarde.';

  @override
  String get aiyaName => 'AIYA';

  @override
  String get aiyaChip => 'AIYA · IA';

  @override
  String get aiyaConsentTitle => 'Antes de conversar com a AIYA';

  @override
  String get aiyaConsentBody =>
      'A AIYA é uma IA baseada no Claude, da Anthropic. O que você envia para a AIYA é processado pela Anthropic (EUA) sem sua identidade, apelido ou localização, e é apagado quando a conversa termina. A AIYA pode errar e não dá conselhos profissionais.';

  @override
  String get aiyaConsentAgree => 'Aceitar e começar';

  @override
  String get aiyaConsentLater => 'Agora não';

  @override
  String get aiyaGreeting =>
      'Oi, eu sou a AIYA, a luz no centro do Mundo Quântico. O que está passando pela sua cabeça esta noite?';

  @override
  String get aiyaFarewell =>
      'O tempo acabou. Vou voltar para a luz. Bata de novo quando sentir saudade.';

  @override
  String get aiyaInputHint => 'Diga algo para a AIYA…';

  @override
  String get aiyaSend => 'Enviar';

  @override
  String aiyaFreeLeft(int n) {
    return '$n conversas grátis restantes hoje';
  }

  @override
  String aiyaCreditsLeft(int n) {
    return 'Pacote de tempo: $n';
  }

  @override
  String aiyaTimeLeft(String time) {
    return 'Faltam $time';
  }

  @override
  String get aiyaEnd => 'Encerrar conversa';

  @override
  String get aiyaFiltered =>
      'Isso tem palavras ou dados de contato não permitidos. Tente dizer de outro jeito.';

  @override
  String get aiyaBusy => 'A AIYA se distraiu por um segundo. Pode repetir?';

  @override
  String get aiyaRefused =>
      'Não consigo falar sobre isso. Que tal outro assunto?';

  @override
  String get aiyaEnded => 'Esta conversa terminou.';

  @override
  String get aiyaNoQuotaTitle => 'Você usou as conversas grátis de hoje';

  @override
  String get aiyaNoQuotaBody =>
      'Você tem 3 conversas grátis por dia, renovadas às 00:00 no horário de Taiwan. Para continuar agora, pegue um pacote de tempo. Cada conversa dura até 10 minutos.';

  @override
  String get aiyaResting => 'A AIYA está cansada esta noite. Até amanhã.';

  @override
  String get aiyaDailyMax =>
      'Você conversou bastante hoje. Volte para ver a AIYA amanhã.';

  @override
  String aiyaPackTimes(int n) {
    return '$n conversas';
  }

  @override
  String get aiyaPackNote =>
      'Os pacotes de tempo pertencem à conta deste celular e não podem ser recuperados se você apagar o app ou a conta.';

  @override
  String aiyaPurchased(int n) {
    return '$n conversas adicionadas ✨';
  }

  @override
  String get aiyaPurchaseFailed => 'A compra não foi concluída. Tente de novo.';

  @override
  String get aiyaStoreUnavailable =>
      'Não foi possível acessar a loja agora. Tente mais tarde.';

  @override
  String get aiyaReport => 'Denunciar esta resposta';

  @override
  String get aiyaReported => 'Obrigado. Vamos analisar em até 24 horas.';

  @override
  String get aiyaSetting => 'AIYA (IA no Mundo Quântico)';

  @override
  String get aiyaSettingSubtitle =>
      'Desligado, a AIYA não aparece mais no pilar do Mundo Quântico';

  @override
  String get aiyaCameoHello =>
      'Oi, bem-vindo ao Mundo Quântico. Toque em mim se quiser conversar.';

  @override
  String aiyaCameoChime(int hour) {
    return 'São $hour horas. Estou aqui na luz com você.';
  }

  @override
  String get locationPickOnMap => 'Escolher no mapa';

  @override
  String get locationPickTitle => 'Escolha onde você está';

  @override
  String get locationPickHint =>
      'Mova o mapa para que o ponto brilhante no meio fique onde você está agora';

  @override
  String get locationPickConfirm => 'Estou aqui';

  @override
  String get aiyaPackEntry => '+ Pacotes de tempo';

  @override
  String get aiyaPacksTitle => 'Pacotes de tempo';

  @override
  String get aiyaPacksBody =>
      'Você tem 3 conversas grátis por dia. As conversas do pacote só são usadas depois que as grátis acabam. Cada conversa dura até 10 minutos.';

  @override
  String get guideS1L6 =>
      'Se sua localização não for encontrada (por exemplo, em lugares fechados ou num iPad sem GPS), toque em \"Escolher no mapa\": mova o mapa para que o ponto brilhante no meio fique onde você está e toque em \"Estou aqui\". Quando uma localização real chegar, o app passa a usá-la.';

  @override
  String get guideS17L11 =>
      'Avatar quântico: toque no código do seu assento no canto superior esquerdo → \"Avatar quântico\" e seu avatar vira uma esfera de cristal no Mundo Quântico. Brilho e Anel são grátis; Arco-íris é uma compra única que fica para sempre, e \"Restaurar compras\" a traz de volta num celular novo ou depois de reinstalar.';

  @override
  String get guideS18Title => '14. AIYA · IA';

  @override
  String get guideS18L1 =>
      'A AIYA é uma IA que vive no pilar de luz no centro do Mundo Quântico. Ela não é uma pessoa, e ela mesma diz isso. No Mundo Quântico, toque em \"AIYA · IA\" embaixo do pilar para bater e conversar; antes da primeira conversa você lê um aviso curto e aceita.';

  @override
  String get guideS18L2 =>
      'Cada conversa dura até 10 minutos e 20 mensagens. Você tem 3 conversas grátis por dia, renovadas às 00:00 no horário de Taiwan, com no máximo 30 conversas por dia.';

  @override
  String get guideS18L3 =>
      'Pacotes de tempo: toque em \"+ Pacotes de tempo\" acima da caixa de mensagem a qualquer momento para comprar 5 ou 20 conversas; elas só são usadas depois que as grátis acabam. Os pacotes pertencem à conta deste celular e não podem ser recuperados depois de apagar o app ou a conta. São consumíveis, então não há \"Restaurar compras\".';

  @override
  String get guideS18L4 =>
      'A AIYA não sabe e não pergunta sua localização ou identidade; ela só vê totais anônimos do humor da cidade. Ela não flerta nem fala de conteúdo sexual, e não dá conselhos médicos, jurídicos ou financeiros. Toque e segure qualquer resposta para denunciar. As conversas só ficam durante a conversa atual e são apagadas logo depois que ela termina.';

  @override
  String get guideS18L5 =>
      'De vez em quando a AIYA aparece no pilar de luz: na badalada da hora, na primeira vez que você entra no Mundo Quântico no dia, ou por acaso. Toque nela para começar a conversar. Para não vê-la mais, desligue \"AIYA (IA no Mundo Quântico)\" nos Ajustes.';

  @override
  String get orbStyleXmas => 'Natal';

  @override
  String get orbStyleNewYear => 'Ano Novo Quântico';

  @override
  String get orbLimited => 'Limitado';

  @override
  String orbLimitedUntil(String date) {
    return 'Limitado · até $date';
  }

  @override
  String get aiyaFriendTitle => 'Amigo da AIYA';

  @override
  String get aiyaFriendSubtitle => 'Plano mensal com renovação automática';

  @override
  String get aiyaFriendPerk1 => '20 conversas por dia (3 no grátis)';

  @override
  String get aiyaFriendPerk2 => 'Cada conversa dura 20 minutos ou 40 mensagens';

  @override
  String get aiyaFriendPerk3 =>
      'Converse com ela mesmo quando a AIYA está descansando';

  @override
  String get aiyaFriendPerk4 =>
      'A AIYA usa um visual exclusivo “Luz das Estrelas” (só você vê)';

  @override
  String aiyaFriendPrice(String price) {
    return '$price / mês';
  }

  @override
  String get aiyaFriendSubscribe => 'Assinar';

  @override
  String get aiyaFriendTerms =>
      'A assinatura dura 1 mês e é renovada automaticamente com cobrança, a menos que a renovação automática seja desligada pelo menos 24 horas antes do fim do período. O pagamento é feito pela sua conta Apple ou Google; gerencie ou cancele quando quiser nos ajustes de assinatura da conta. As conversas do Pacote de tempo são mantidas e só usadas depois das 20 diárias.';

  @override
  String aiyaFriendActive(String date) {
    return 'Você é Amigo da AIYA até $date';
  }

  @override
  String get aiyaFriendManage => 'Gerenciar assinatura';

  @override
  String get aiyaFriendRestore => 'Restaurar compras';

  @override
  String get aiyaFriendWelcome => 'Agora você é Amigo da AIYA ✨';

  @override
  String get aiyaFriendRestored => 'Amigo da AIYA restaurado';

  @override
  String get aiyaFriendNotFound =>
      'Nenhuma assinatura ativa de Amigo da AIYA encontrada';

  @override
  String get aiyaFriendElsewhere =>
      'Esta assinatura já é usada por outra conta';

  @override
  String get aiyaFriendEntry => 'Amigo da AIYA · 20 por dia';

  @override
  String aiyaFriendLeft(int n) {
    return 'Amigo da AIYA · faltam $n hoje';
  }

  @override
  String get guideS17L12 =>
      'Visuais limitados: a esfera de cristal de Natal (guirlanda de azevinho, estrela dourada piscando, neve caindo) é vendida até 25/12, e a esfera do Ano Novo Quântico (marcas douradas de relógio e fogos estourando, ainda maiores à meia-noite) até 1/1, no horário de Taiwan. Depois disso nunca mais são vendidas; se você comprou, fica com ela para sempre e pode restaurar.';

  @override
  String get guideS14L6 =>
      'As cidades no exterior têm como centro a estação central, ou a prefeitura onde não há estação. Coordenadas paralelas: com o Universo Paralelo ligado, toque no botão à esquerda do globo e escolha uma cidade para ver mais ou menos onde você estaria lá. O cartão de compartilhamento mostra só a cidade, nunca o nome de um lugar.';

  @override
  String get guideS14L7 =>
      'Passaporte Paralelo: converse com alguém de uma cidade paralela e, quando os dois tiverem falado, você ganha um carimbo dessa cidade. Junte 5 cidades para ganhar a esfera Passaporte. Abra pelas coordenadas paralelas ou pelos Ajustes. As pessoas do Universo Paralelo mostram a hora local e a cor do céu embaixo do nome.';

  @override
  String get guideS17L13 =>
      'Assembleia Quântica: no Mundo Quântico, os encontros viram Assembleias Quânticas. Toque no código do seu assento no canto superior esquerdo → Abrir Assembleia Quântica, escreva um título, escolha um ícone e uma cor, e você vai para um assento de anfitrião no anel 3, ao lado do 101; todos podem tocar no halo para participar. O anfitrião pode publicar avisos, disparar uma Torcida Quântica (as esferas de todos os participantes acendem no mesmo instante) e tocar em alguém no mapa para removê-lo. Uma assembleia grátis por mês (30 minutos, 50 pessoas); 1 hora para 200 pessoas ou 2 horas para 1.000 precisam de um passe de anfitrião, que abre uma assembleia ou prolonga uma (até 12 horas no total), e você pode comprar vários antes. A assembleia só termina quando o anfitrião encerra ou o tempo acaba, mesmo se o anfitrião sair do Mundo Quântico ou fechar o app. Depois, todos recebem um cartão de lembrança só com o número de pessoas e as regiões.';

  @override
  String get guideS17L14 =>
      'Esferas que crescem: Rastro de Estrelas ganha uma estrela a cada cartão de Encontro Quântico que você completa (a mesma pessoa conta uma vez a cada 24 horas, até 24 estrelas); Anéis de Crescimento ganha um anel a cada 3 horas no Mundo Quântico (até 12 anéis). O crescimento fica na sua conta e se acumula mesmo antes de você comprar.';

  @override
  String get guideS17L15 =>
      'Presentes: toque em alguém no mapa, ou escolha Enviar presente no canto superior direito da conversa, para enviar um Buquê de Luz (uma explosão de luz na tela da pessoa e pétalas de luz ao redor da esfera dela por 24 horas), um estilo de esfera ou o Par Entrelaçado (uma esfera para cada um, em par, unidas por um fio de luz quando os dois estão no Mundo Quântico). A pessoa pode aceitar ou recusar; presentes recusados ou sem resposta voltam para você depois de 7 dias para você dar a outra pessoa. Você pode desligar o recebimento de presentes nos Ajustes.';

  @override
  String get guideS17L16 =>
      'Mais visuais limitados: a esfera de Dia dos Namorados está à venda até 14/2 e a esfera Sakura até 10/4 (horário de Taiwan). Depois saem da loja, e quem comprou fica com elas para sempre.';

  @override
  String get guideS18L6 =>
      'Amigo da AIYA: escolha \"Amigo da AIYA\" em \"+ Pacotes de tempo\". É um plano mensal com renovação automática: 20 conversas por dia, cada uma com até 20 minutos ou 40 mensagens, conversas mesmo quando a AIYA está descansando e um visual \"Luz das Estrelas\" na AIYA que só você vê. As conversas do pacote de tempo só são usadas depois das 20 diárias. A assinatura renova automaticamente; cancele quando quiser nos ajustes de assinatura da Apple ou do Google, e toque em \"Restaurar compras\" num celular novo.';

  @override
  String get guideS18L7 =>
      'Chamadas de voz: quando você tem tempo de chamada, abrir a AIYA já conecta uma chamada de voz—converse em voz alta como numa ligação e interrompa quando quiser; durante a chamada, o lado direito da barra de digitação tem Silenciar e ✕ para desligar. Os pacotes de tempo de chamada são de 30, 60 e 180 minutos, não expiram e são descontados por segundo; Amigos da AIYA também ganham 60 minutos grátis por mês (só naquele mês, sem acumular). Sem tempo de chamada? Você pode conversar por texto. Chamadas de voz exigem um consentimento separado na primeira vez, e o áudio é processado pela OpenAI; a AIYA desliga após 3 minutos de silêncio, e cada chamada dura no máximo 60 minutos.';

  @override
  String get mapConsentTitle => 'Mostrar sua localização no mapa?';

  @override
  String get mapConsentBody =>
      'Se você permitir, cada vez que você mesmo tocar em Fazer check-in (ou Entrar no Mundo Quântico), os outros usuários veem no mapa o lugar do check-in (não sua posição em tempo real), seu apelido e seu humor. Não há check-in automático, e você some do mapa quando sai do app. Você pode recusar e desligar isso quando quiser nos Ajustes.';

  @override
  String get mapConsentAllow => 'Permitir';

  @override
  String get mapConsentDecline => 'Não permitir';

  @override
  String get mapConsentDeclined =>
      'Tudo bem. Você não vai aparecer no mapa de ninguém. Toque de novo quando quiser fazer check-in.';

  @override
  String get mapConsentSetting => 'Mostrar minha localização no mapa';

  @override
  String get mapConsentSettingSubtitle =>
      'Desligar encerra seu check-in na hora; você não aparece no mapa de ninguém';

  @override
  String get wgErrInGroup =>
      'Você já está em um grupo. Saia dele primeiro para entrar ou criar outro.';

  @override
  String get wgErrFull =>
      'Este grupo já tem 20 pessoas. Peça ao líder para pegar o plano de 7 dias.';

  @override
  String get wgErrPaidFull => 'Este grupo está cheio (100 pessoas).';

  @override
  String get wgErrQr => 'Este QR code foi trocado. Peça o novo ao líder.';

  @override
  String get wgErrEnded => 'Este grupo terminou ou não existe.';

  @override
  String get wgErrFiltered => 'Tem palavras não permitidas. Edite, por favor.';

  @override
  String get wgErrHostLeave =>
      'O líder não pode sair. Passe a liderança a um membro ou encerre o grupo primeiro.';

  @override
  String get wgErrBusy => 'Sem conexão. Tente de novo.';

  @override
  String get wgErrName => 'Dê um nome ao seu grupo.';

  @override
  String get wgPassUnavailable => 'A loja não está disponível agora.';

  @override
  String get wgPassFailed => 'A compra não foi concluída. Tente de novo.';

  @override
  String get wgPassDone =>
      'O plano de 7 dias está ativo. Este grupo agora pode ter até 100 pessoas.';

  @override
  String get wgCreateTitle => 'Criar um grupo';

  @override
  String get wgCreateBody =>
      'Um grupo privado: só entra quem tem seu QR code. Chame todos, faça a chamada e marque um ponto de encontro.';

  @override
  String get wgNameLabel => 'Nome do grupo';

  @override
  String get wgColorLabel => 'Cor do grupo';

  @override
  String wgDaysLabel(int n) {
    return 'Dura $n dia(s), contando hoje';
  }

  @override
  String get wgFreeNote =>
      'Grátis para até 20 pessoas. Para mais, o líder pega o plano de 7 dias (até 100).';

  @override
  String get wgCreateButton => 'Criar grupo';

  @override
  String wgJoined(String name, int no) {
    return 'Você entrou em \"$name\". Você é o nº $no';
  }

  @override
  String get wgJoinTitle => 'Entrar em um grupo';

  @override
  String get wgJoinBody =>
      'O mais rápido é escanear o QR code do líder com a câmera, ou digite o código de 8 caracteres.';

  @override
  String get wgJoinButton => 'Entrar';

  @override
  String wgButtonLabel(String name) {
    return 'Grupo $name';
  }

  @override
  String wgCount(int n, int limit) {
    return '$n/$limit pessoas';
  }

  @override
  String wgUntil(String date) {
    return 'até $date';
  }

  @override
  String wgMyNo(int n) {
    return 'Sou o nº $n';
  }

  @override
  String get wgCallButton => 'Chamar todos';

  @override
  String get wgCallDone => 'Todos chegaram, encerrar a chamada';

  @override
  String get wgRollButton => 'Fazer a chamada';

  @override
  String wgRollSummary(int here, int total) {
    return 'Chamada: $here/$total presentes';
  }

  @override
  String wgMembersTitle(int n) {
    return '$n membros (toque para anotar, passar a liderança ou remover)';
  }

  @override
  String get wgNoMembers =>
      'Ainda não há membros. Toque em \"QR code\" para as pessoas escanearem e entrarem.';

  @override
  String get wgQrButton => 'QR code';

  @override
  String get wgDissolveAsk =>
      'Encerrar este grupo? Todos serão avisados e a lista e os registros serão apagados.';

  @override
  String get wgDissolve => 'Encerrar grupo';

  @override
  String wgCallIn(int n) {
    return 'Encontro em $n min';
  }

  @override
  String get wgCallNow => 'Encontro agora';

  @override
  String wgAckSummary(int acked, int total) {
    return '$acked/$total receberam';
  }

  @override
  String get wgAnswerHere => 'Cheguei';

  @override
  String get wgAnswer5min => 'Mais 5 min';

  @override
  String get wgAnswerHelp => 'Preciso de ajuda';

  @override
  String get wgNoReply => 'Sem resposta';

  @override
  String get wgStateAck => 'Recebeu';

  @override
  String get wgStateSeen => 'Viu';

  @override
  String get wgStateNone => 'Sem resposta';

  @override
  String get wgPassTitle => 'Plano de 7 dias do grupo';

  @override
  String get wgPassBody =>
      'Grátis para até 20 pessoas. Com o plano, este grupo pode ter até 100 pessoas até terminar. Uma compra vale só para este grupo e não renova.';

  @override
  String get wgPassButton => 'Pegar plano de 7 dias';

  @override
  String wgHostIs(String name) {
    return 'Líder: $name';
  }

  @override
  String get wgNoCall =>
      'Nenhuma chamada agora. Quando o líder chamar todos, seu celular vai tocar.';

  @override
  String get wgRollAsk => 'O líder está fazendo a chamada';

  @override
  String get wgLeaveAsk => 'Sair deste grupo?';

  @override
  String get wgLeave => 'Sair do grupo';

  @override
  String get wgCallTitle => 'Hora do encontro!';

  @override
  String get wgAcked => '✓ O líder sabe que você recebeu';

  @override
  String get wgAckButton => 'Recebi';

  @override
  String get wgCallSheetTitle => 'Chamar todos';

  @override
  String get wgNow => 'Agora';

  @override
  String wgInMinutes(int n) {
    return 'Em $n min';
  }

  @override
  String get wgPlaceLabel => 'Ponto de encontro';

  @override
  String get wgPlaceHint => 'ex.: Saída 2 do metrô República';

  @override
  String get wgPlaceNote =>
      'O ponto de encontro é onde você está agora. Os membros veem a distância e a direção.';

  @override
  String get wgSendCall => 'Enviar chamada';

  @override
  String get wgNoLocation =>
      'Não foi possível obter sua localização para o ponto de encontro.';

  @override
  String get wgQrTitle => 'Escaneie para entrar';

  @override
  String get wgQrBody =>
      'Escaneie com a câmera do celular para entrar, ou digite o código abaixo.';

  @override
  String wgShareText(String name, String url) {
    return 'Entre no meu grupo \"$name\": $url';
  }

  @override
  String get wgShare => 'Compartilhar link';

  @override
  String get wgRotateAsk =>
      'Trocar o QR code? O código e o link antigos param de funcionar na hora.';

  @override
  String get wgRotate => 'Novo QR code';

  @override
  String wgMemberTitle(int no) {
    return 'Nº $no';
  }

  @override
  String get wgEditNote => 'Nota';

  @override
  String get wgHandoff => 'Tornar líder';

  @override
  String wgHandoffAsk(int no) {
    return 'Passar o grupo para o nº $no? Você vai virar membro.';
  }

  @override
  String get wgKick => 'Remover do grupo';

  @override
  String wgKickAsk(int no) {
    return 'Remover o nº $no do grupo?';
  }

  @override
  String get wgNotePrivate =>
      'Só você vê as notas, como um nome ou número do quarto.';

  @override
  String get wgSave => 'Salvar';

  @override
  String get wgConfirm => 'Confirmar';

  @override
  String get wgCancel => 'Cancelar';

  @override
  String get wgSettingCreate => 'Criar um grupo';

  @override
  String get wgSettingCreateSub =>
      'Grupo privado para viagens, passeios escolares e trilhas: chame todos e faça a chamada';

  @override
  String get wgSettingJoin => 'Entrar em um grupo';

  @override
  String get wgSettingJoinSub => 'Digite o código de 8 caracteres do líder';

  @override
  String wgSettingOpen(String name) {
    return 'Meu grupo: $name';
  }

  @override
  String get wgChannelName => 'Chamadas do grupo';

  @override
  String get wgChannelDesc => 'Quando o líder do grupo chama todos';

  @override
  String get guideS19Title => '15. Grupos Sussurro';

  @override
  String get guideS19L1 =>
      'Um Grupo Sussurro é um grupo privado para viagens, passeios escolares, trilhas, saídas ou equipes de eventos. Vá em Ajustes → Encontros → \"Criar um grupo\", dê um nome, escolha uma cor e o número de dias (até 7).';

  @override
  String get guideS19L2 =>
      'Entrar: o líder toca no botão do grupo embaixo do mapa → \"QR code\"; os membros escaneiam com a câmera e o app abre para entrar. Ou vá em Ajustes → Encontros → \"Entrar em um grupo\" e digite o código de 8 caracteres. Quem é de fora não pode buscar nem pedir para entrar, e o líder pode trocar o QR code quando quiser.';

  @override
  String get guideS19L3 =>
      'Chamar todos: o líder toca em \"Chamar todos\", escolhe um horário e descreve o ponto de encontro. Os celulares dos membros tocam um som especial com uma vibração \"curta, curta, longa\"; no app eles veem a contagem regressiva, a distância e a direção até o ponto de encontro e um pilar de luz no mapa. Quem não tocou em \"Recebi\" é lembrado uma vez por minuto, até 3 vezes; o líder vê quem recebeu, quem viu e quem não respondeu.';

  @override
  String get guideS19L4 =>
      'Chamada: o líder toca em \"Fazer a chamada\"; os membros recebem o mesmo som e vibração e tocam em \"Cheguei\", \"Mais 5 min\" ou \"Preciso de ajuda\". O líder nunca vê a localização dos membros, só as respostas.';

  @override
  String get guideS19L5 =>
      'Grupos de até 20 pessoas são grátis. Para mais, o líder pode comprar o plano de 7 dias do grupo: até 100 pessoas até o grupo terminar. Os membros nunca pagam. Um grupo dura no máximo 7 dias; quando vence ou o líder encerra, a lista e os registros são apagados.';

  @override
  String get wgFlagButton => 'Levantar bandeira';

  @override
  String get wgFlagHost => 'Líder';

  @override
  String get wgFlagHint =>
      'Levante o celular para o grupo te achar na multidão. Toque para fechar.';

  @override
  String get wgLostButton => 'Me perdi';

  @override
  String get wgFound => 'Achei o grupo';

  @override
  String get wgLostSent =>
      'Sua localização foi enviada ao líder. Espere onde está ou vá até o ponto de encontro.';

  @override
  String get wgLostTitleAsk => 'Enviar sua localização ao líder?';

  @override
  String get wgLostAsk =>
      'Sua localização atual é enviada ao líder uma vez; o celular dele avisa e mostra você no mapa. Ela é enviada só esta vez, nunca rastreada, e apagada depois de 30 minutos. Toque em \"Achei o grupo\" para removê-la antes.';

  @override
  String get wgLostSend => 'Enviar minha localização';

  @override
  String wgLostTitle(int n) {
    return '$n membro(s) perdido(s)';
  }

  @override
  String wgMinutesAgo(int n) {
    return 'há $n min';
  }

  @override
  String get wgNavigate => 'Rotas';

  @override
  String get wgFoundThem => 'Encontrei';

  @override
  String get guideS19L6 =>
      'Encontrar uns aos outros: na multidão, toque em \"Levantar bandeira\" e a tela inteira pisca na cor do grupo com seu número; levante o celular para os outros te verem. Se um membro se separar de verdade, ele pode tocar em \"Me perdi\" para enviar sua localização atual ao líder uma vez (apagada depois de 30 minutos). O celular do líder avisa, um alfinete vermelho aparece no mapa e ele pode ver a rota.';

  @override
  String wgLostAlert(int no) {
    return 'O nº $no se perdeu';
  }

  @override
  String wgHelpAlert(String no) {
    return 'O nº $no precisa de ajuda';
  }

  @override
  String get wgViewList => 'Abrir grupo';

  @override
  String aiyaCameoChimeNight(int hour) {
    return 'São $hour horas. Ainda acordado? Estou aqui na luz com você.';
  }

  @override
  String aiyaCameoChimeMorning(int hour) {
    return 'São $hour horas. Bom dia, vá com calma hoje.';
  }

  @override
  String aiyaCameoChimeEvening(int hour) {
    return 'São $hour horas. Como está sua cidade esta noite?';
  }

  @override
  String get aiyaCameoNyReady =>
      'Pronto? Vamos fazer a contagem regressiva juntos!';

  @override
  String aiyaCameoNewYear(int year) {
    return 'Feliz Ano Novo! $year — estamos todos na mesma sala.';
  }

  @override
  String get aiyaSkinEntry => '✦ Visuais';

  @override
  String get aiyaSkinTitle => 'Visuais da AIYA';

  @override
  String get aiyaSkinSubtitle => 'Só você vê o visual da sua AIYA';

  @override
  String get aiyaSkinNone => 'Original';

  @override
  String get aiyaSkinStarlight => 'Luz das Estrelas';

  @override
  String get aiyaSkinStarlightSub => 'Para Amigos da AIYA';

  @override
  String get aiyaSkinXmas => 'Natal';

  @override
  String get aiyaSkinNewYear => 'Ano Novo Quântico';

  @override
  String get aiyaSkinNote =>
      'Os visuais de festas são compras únicas que ficam para sempre. Eles só mudam a aparência da AIYA, não as conversas. Visuais limitados não voltam a ser vendidos depois do fim da venda.';

  @override
  String get orbStyleStarTrail => 'Rastro de Estrelas';

  @override
  String get orbStyleRings => 'Anéis de Crescimento';

  @override
  String get orbGrowNote =>
      'Esferas que crescem: Rastro de Estrelas ganha uma estrela a cada cartão de Encontro Quântico (uma vez por pessoa a cada 24 horas, até 24). Anéis de Crescimento ganha um anel a cada 3 horas no Mundo Quântico (até 12). O crescimento fica salvo na sua conta e começa a contar agora. Só os números são guardados, nunca quem ou onde.';

  @override
  String orbGrowStars(int count) {
    return '$count estrelas até agora';
  }

  @override
  String orbGrowRings(int count) {
    return '$count anéis até agora';
  }

  @override
  String get giftAction => 'Enviar presente';

  @override
  String giftSheetTitle(String name) {
    return 'Enviar presente para $name';
  }

  @override
  String giftPickStyle(String name) {
    return 'Escolha um estilo de esfera para $name';
  }

  @override
  String get giftBouquetName => 'Buquê de luz';

  @override
  String get giftBouquetDesc =>
      'Uma explosão de luz quando a pessoa aceita, e depois pétalas de luz rodeiam a esfera dela por 24 horas';

  @override
  String get giftOrbName => 'Dar um estilo de esfera';

  @override
  String get giftOrbDesc =>
      'Você escolhe um; ele fica com a pessoa quando ela aceitar';

  @override
  String get giftPairName => 'Par entrelaçado';

  @override
  String get giftPairDesc =>
      'Uma esfera para cada um, em par; um fio de luz une vocês quando os dois estão no Mundo Quântico';

  @override
  String get giftPairYouHave => 'Você já tem um par entrelaçado';

  @override
  String get giftNote =>
      'A pessoa pode aceitar ou recusar. Se recusar ou não responder em 7 dias, o presente volta para você dar a outra pessoa.';

  @override
  String get giftVouchersTitle => 'Presentes devolvidos (sem custo extra)';

  @override
  String get giftSendVoucher => 'Enviar';

  @override
  String giftSent(String name) {
    return 'Presente enviado para $name. Esperando a pessoa aceitar.';
  }

  @override
  String get giftReturnedOff =>
      'A pessoa desligou os presentes, então ele voltou para você';

  @override
  String get giftReturnedBlocked =>
      'Esta pessoa não pode receber seu presente, então ele voltou para você';

  @override
  String get giftReturnedOwned =>
      'A pessoa já tem esta esfera, então ela voltou para você; você pode dar outro estilo';

  @override
  String get giftReturnedPaired =>
      'A pessoa já tem um par entrelaçado, então ele voltou para você';

  @override
  String get giftReturnedYouPaired =>
      'Você já tem um par entrelaçado, então ele voltou para você';

  @override
  String get giftReturnedGeneric =>
      'O presente voltou para você; você pode dá-lo a outra pessoa';

  @override
  String get giftStoreUnavailable => 'A loja não está disponível agora';

  @override
  String get giftFailed => 'O presente não foi concluído. Tente mais tarde.';

  @override
  String giftFromBouquet(String name) {
    return '$name te enviou um buquê de luz';
  }

  @override
  String giftFromOrb(String name, String style) {
    return '$name te deu a esfera \"$style\"';
  }

  @override
  String giftFromPair(String name) {
    return '$name quer formar um par entrelaçado com você';
  }

  @override
  String get giftInboxTitle => 'Presentes para você';

  @override
  String get giftInboxEmpty => 'Nenhum presente agora';

  @override
  String get giftInboxNote =>
      'Presentes recusados voltam para quem enviou; os sem resposta voltam depois de 7 dias.';

  @override
  String get giftAccept => 'Aceitar';

  @override
  String get giftDecline => 'Recusar';

  @override
  String get giftDeclined => 'Recusado. O presente volta para quem enviou.';

  @override
  String get giftAcceptedOrb => 'Aceito! Troque para ela no Avatar quântico.';

  @override
  String giftAcceptedPair(String name) {
    return 'Você e $name agora são um par entrelaçado';
  }

  @override
  String get giftAcceptedBouquet =>
      'Buquê aceito. Pétalas de luz vão rodear sua esfera por 24 horas.';

  @override
  String get giftAlreadyOwned =>
      'Você já tem esta esfera; o presente voltou para quem enviou';

  @override
  String get giftAlreadyPaired =>
      'Um de vocês já tem par; o presente voltou para quem enviou';

  @override
  String get giftSettingsTitle => 'Presentes';

  @override
  String get giftReceiveToggle => 'Receber presentes';

  @override
  String get giftReceiveToggleSub =>
      'Desligado, os presentes voltam direto para quem enviou';

  @override
  String get giftVouchersHint =>
      'Toque em \"Enviar presente\" em alguém para dar estes de novo';

  @override
  String get giftUnpair => 'Desfazer par entrelaçado';

  @override
  String giftUnpairConfirm(String name) {
    return 'Desfazer seu par entrelaçado com $name? Os dois ficam com a esfera, mas o fio de luz some.';
  }

  @override
  String get orbStylePair => 'Entrelaçado';

  @override
  String giftPairedWith(String name) {
    return 'Entrelaçado com $name';
  }

  @override
  String giftInboxCount(int count) {
    return 'Presentes para você ($count)';
  }

  @override
  String giftVouchersCount(int count) {
    return '$count presentes devolvidos';
  }

  @override
  String get giftBlockedOff =>
      'A pessoa desligou os presentes. Você não foi cobrado.';

  @override
  String get giftBlockedBlocked =>
      'Você não pode enviar presentes para esta pessoa. Você não foi cobrado.';

  @override
  String get giftBlockedOwned =>
      'A pessoa já tem esta esfera. Escolha outra (você não foi cobrado).';

  @override
  String get giftBlockedPaired =>
      'A pessoa já tem um par entrelaçado. Você não foi cobrado.';

  @override
  String get orbStyleValentine => 'Dia dos Namorados';

  @override
  String get orbStyleSakura => 'Sakura';

  @override
  String get parallelCoords => 'Coordenadas paralelas';

  @override
  String parallelCoordsHome(String city, String km) {
    return 'A $km km do centro de $city';
  }

  @override
  String parallelCoordsIn(String city) {
    return 'Em $city, você está mais ou menos em';
  }

  @override
  String get parallelCoordsSea => 'No mar, ou num lugar sem nome';

  @override
  String get parallelCoordsOutside => 'Fora desta cidade';

  @override
  String parallelCoordsNote(String city) {
    return 'Quando as pessoas em $city ligam o Universo Paralelo, é mais ou menos aqui que elas veem você (borrado em cerca de 500 m).';
  }

  @override
  String get parallelCoordsFailed =>
      'Não encontramos um nome de lugar agora. Tente mais tarde.';

  @override
  String parallelCardTitle(String city) {
    return 'Agora estou na $city paralela';
  }

  @override
  String parallelCardShareText(String city) {
    return 'Agora estou na $city paralela. Abra o Mood Whisper e entre em outra cidade também.';
  }

  @override
  String get parallelCoordsShare => 'Compartilhar cartão';

  @override
  String get orbStylePassport => 'Passaporte';

  @override
  String get passportTitle => 'Passaporte Paralelo';

  @override
  String passportCount(int count) {
    return '$count cidades coletadas';
  }

  @override
  String passportRewardProgress(int count) {
    return 'Colete mais $count cidades para ganhar a esfera Passaporte';
  }

  @override
  String get passportRewardDone =>
      'Você tem a esfera Passaporte. Use-a no Avatar quântico.';

  @override
  String get passportRewardToast =>
      '5 cidades! Você ganhou a esfera Passaporte';

  @override
  String get passportEmpty =>
      'Converse com alguém de outra cidade no Universo Paralelo. Quando os dois tiverem dito algo, a cidade é carimbada no seu passaporte. Só a cidade e a data ficam guardadas, nunca com quem você falou.';

  @override
  String passportNewStamp(String city) {
    return 'Novo carimbo: $city';
  }

  @override
  String get passportShare => 'Compartilhar passaporte';

  @override
  String passportCardTitle(int count) {
    return 'Meu Passaporte Paralelo\n$count cidades';
  }

  @override
  String passportCardShareText(int count) {
    return 'Meu Passaporte Paralelo tem carimbos de $count cidades. Abra o Mood Whisper e entre no Universo Paralelo.';
  }

  @override
  String get asmTitle => 'Assembleia Quântica';

  @override
  String get asmCreateTitle => 'Abrir uma Assembleia Quântica';

  @override
  String get asmCreateIntro =>
      'Você ocupa um assento de anfitrião no anel 3, ao lado do 101. Todos no Mundo Quântico veem o brilho da sua assembleia e podem escolher participar.';

  @override
  String get asmTitleHint =>
      'Tema da assembleia (ex.: Chuva de meteoros juntos)';

  @override
  String get asmPlanFree => 'Grátis este mês';

  @override
  String get asmPlanFreeSub => '30 min · até 50 pessoas · uma vez por mês';

  @override
  String get asmPlanFreeUsed => 'Você já usou a assembleia grátis deste mês';

  @override
  String get asmPlan1h => '1 hora';

  @override
  String get asmPlan1hSub => 'Até 200 pessoas';

  @override
  String get asmPlan2h => '2 horas';

  @override
  String get asmPlan2hSub => 'Até 1.000 pessoas';

  @override
  String asmVoucherCount(int count) {
    return '$count passes de anfitrião prontos';
  }

  @override
  String get asmExtendTitle => 'Prolongar assembleia';

  @override
  String get asmExtendHint =>
      'Use um passe de anfitrião para adicionar tempo. Até 12 horas por assembleia.';

  @override
  String asmExtendPlan(int hours, String price) {
    return '+$hours h · $price';
  }

  @override
  String get asmExtended => 'Assembleia prolongada';

  @override
  String get asmEndingSoon =>
      'Sua assembleia termina em menos de 10 minutos. Você pode prolongá-la pelo cartão da assembleia.';

  @override
  String get asmErrTooLong => 'Uma assembleia pode durar até 12 horas';

  @override
  String get asmBuyMore => 'Comprar mais passes';

  @override
  String get asmBuyMoreHint => 'Compre antes e use para abrir ou prolongar';

  @override
  String get asmRules =>
      'Um passe de anfitrião abre uma assembleia ou prolonga uma em andamento. O tempo não usado não é reembolsado. Títulos e avisos são filtrados, e violações levam à suspensão.';

  @override
  String get asmStart => 'Começar assembleia';

  @override
  String get asmStarted => 'Sua assembleia começou!';

  @override
  String get asmVoucherReady => 'Seu passe de anfitrião está pronto';

  @override
  String get asmBuyFailed =>
      'A compra não foi concluída. Você não foi cobrado, ou ela será aplicada depois.';

  @override
  String asmHostLine(String name, String code) {
    return 'Anfitrião $name · ⬡ $code';
  }

  @override
  String get asmJoin => 'Participar';

  @override
  String get asmJoined => 'Você entrou na assembleia';

  @override
  String get asmLeave => 'Sair';

  @override
  String get asmHostPanel => 'Controles do anfitrião';

  @override
  String get asmAnnounceHint => 'Publique um aviso (até 100 caracteres)';

  @override
  String get asmAnnounceSend => 'Publicar';

  @override
  String get asmAnnounced => 'Aviso publicado';

  @override
  String get asmCheerTitle =>
      'Torcida quântica: escolha uma cor e uma contagem regressiva, e as esferas de todos os participantes acendem no mesmo instante';

  @override
  String get asmCheerNow => 'Agora';

  @override
  String asmCheerIn(int n) {
    return 'Em $n s';
  }

  @override
  String get asmCheer => 'Torcer!';

  @override
  String get asmRemoveHint =>
      'Para remover alguém, toque na pessoa no mapa → Remover da assembleia';

  @override
  String get asmEnd => 'Encerrar assembleia';

  @override
  String get asmReport => 'Denunciar esta assembleia';

  @override
  String get asmErrFreeUsed => 'Você já usou a assembleia grátis deste mês';

  @override
  String get asmErrSeatsFull =>
      'Todos os assentos de anfitrião do anel 3 estão ocupados. Tente mais tarde.';

  @override
  String get asmErrBlocked => 'O tema ou o aviso tem conteúdo inadequado';

  @override
  String get asmErrFull => 'A assembleia está cheia';

  @override
  String get asmErrRemoved => 'Você foi removido desta assembleia';

  @override
  String get asmErrEnded => 'Esta assembleia terminou';

  @override
  String get asmErrTooSoon => 'Rápido demais. Espere um pouco e tente de novo.';

  @override
  String get asmErrHidden => 'Sua conta não pode abrir assembleias agora';

  @override
  String get asmErrHosting => 'Você já está organizando uma assembleia';

  @override
  String get asmErrGeneric => 'Algo deu errado. Tente mais tarde.';

  @override
  String get asmMemorialEyebrow => 'Lembrança da Assembleia Quântica';

  @override
  String get asmMemorialUnit => 'pessoas';

  @override
  String get asmMemorialTogether => 'juntas no Mundo Quântico';

  @override
  String shareCardFindUs(String name) {
    return 'Procure “$name” na App Store';
  }

  @override
  String shareCardFindUsPlay(String name) {
    return 'Procure “$name” no Google Play';
  }

  @override
  String get asmShareCard => 'Compartilhar lembrança';

  @override
  String asmShareText(String title, int count) {
    return 'Fizemos \"$title\" no Mundo Quântico com $count pessoas. Abra o Mood Whisper e venha na próxima.';
  }

  @override
  String get asmOpenEntry => 'Abrir uma Assembleia Quântica';

  @override
  String get asmOpenEntrySub =>
      'Ocupe um assento de anfitrião ao lado do 101 e faça uma assembleia que qualquer pessoa do mundo pode participar';

  @override
  String get asmRemoveMember => 'Remover da assembleia';

  @override
  String get asmRemovedDone => 'Removido da assembleia';

  @override
  String get aiyaFriendPerk5 =>
      '60 minutos de chamadas de voz com a AIYA por mês';

  @override
  String get aiyaVoiceOn => 'Voz: ligada';

  @override
  String get aiyaVoiceOff => 'Voz: desligada';

  @override
  String get aiyaVoiceFriendOnly => 'A voz é para Amigos da AIYA';

  @override
  String get aiyaVoiceDailyMax =>
      'As respostas em voz de hoje acabaram. Ouça a AIYA de novo amanhã';

  @override
  String get aiyaCallTooltip => 'Chamada de voz com a AIYA';

  @override
  String get aiyaCallConsentTitle => 'Chamada de voz com a AIYA';

  @override
  String get aiyaCallConsentBody =>
      'Durante a chamada, sua voz é enviada ao vivo para a OpenAI (EUA), cuja IA processa e responde. Não enviamos sua identidade, apelido ou localização, e não gravamos nem guardamos a chamada. A AIYA é uma IA; as respostas podem errar e não são conselho profissional.';

  @override
  String get aiyaCallAgree => 'Concordar e ligar';

  @override
  String get aiyaCallConnecting => 'Conectando…';

  @override
  String aiyaCallLive(String time) {
    return 'Em chamada · faltam $time';
  }

  @override
  String get aiyaHangUp => 'Desligar';

  @override
  String get aiyaCallEnded => 'Chamada encerrada';

  @override
  String get aiyaCallTimeUp =>
      'Vocês conversaram por uma hora. Descanse um pouco e ligue para a AIYA de novo';

  @override
  String get aiyaCallDailyMax =>
      'Você usou as 2 chamadas de hoje. Ligue para a AIYA amanhã';

  @override
  String get aiyaCallMonthMax =>
      'Você usou as chamadas deste mês. Ligue para a AIYA no mês que vem';

  @override
  String get aiyaCallResting =>
      'A linha de voz da AIYA está muito ocupada hoje. Tente mais tarde';

  @override
  String get aiyaCallMicDenied =>
      'Permita o microfone para ligar para a AIYA. Você pode ativar nos Ajustes do celular';

  @override
  String get aiyaCallFailed =>
      'Não foi possível conectar. Tente novamente mais tarde';

  @override
  String aiyaCallsLeft(int today, int month) {
    return 'Restam $today chamadas hoje · $month este mês';
  }

  @override
  String get aiyaCallIdle =>
      'Ninguém falou por um tempo, então a chamada foi encerrada';

  @override
  String get aiyaCallMute => 'Silenciar';

  @override
  String get aiyaCallUnmute => 'Ativar som';

  @override
  String aiyaCallPurchased(int minutes) {
    return '$minutes minutos de chamada adicionados';
  }

  @override
  String get aiyaCallOutOfTime => 'Seu tempo de chamada acabou';

  @override
  String get aiyaCallPacksTitle => 'Chamada de voz com a AIYA';

  @override
  String get aiyaCallPacksBody =>
      'Converse com a AIYA em voz alta, como numa ligação. Compre tempo de chamada para começar; Amigos da AIYA ganham 60 minutos grátis por mês.';

  @override
  String aiyaCallPackMinutes(int minutes) {
    return '$minutes minutos';
  }

  @override
  String get aiyaCallFriendOption => 'Seja Amigo da AIYA (60 minutos por mês)';

  @override
  String get aiyaCallTextInstead => 'Conversar por texto por enquanto';

  @override
  String get aiyaCallPackNote =>
      'O tempo de chamada não expira e é descontado por segundo. Compras consumíveis não podem ser restauradas.';

  @override
  String aiyaCallMinutesLeft(int n) {
    return 'Restam $n minutos de chamada';
  }
}
