// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get checkInEnter => 'Registrarme aquí y entrar';

  @override
  String get checkInNote =>
      'Al tocar, las personas cercanas verán tu estado de ánimo y más o menos dónde estás. Te registras tú mismo cada vez que entras.';

  @override
  String get checkInTitle => 'Regístrate en la ciudad';

  @override
  String get checkInBody =>
      'Después de registrarte, las personas cercanas pueden ver tu estado de ánimo y más o menos dónde estás, y tú también las ves. Ven el lugar donde te registraste; no te sigue. Te registras tú mismo cada vez que abres la app; nunca ocurre automáticamente. Al salir o cambiar a otra app, tu registro termina.';

  @override
  String get checkInButton => 'Registrarme aquí';

  @override
  String get checkInAgain =>
      'Te alejaste de donde te registraste · Registrarme aquí';

  @override
  String get checkOutButton => 'Registrado · Salir';

  @override
  String get checkedOutToast => 'Saliste. Ya no apareces en el mapa.';

  @override
  String get appName => 'Mood Whisper';

  @override
  String get moodJoy => 'Feliz';

  @override
  String get moodSad => 'Triste';

  @override
  String get moodAngry => 'Enojado';

  @override
  String get moodCalm => 'Tranquilo';

  @override
  String get moodPassion => 'Con energía';

  @override
  String get moodLove => 'Amor';

  @override
  String get moodOther => 'Otro';

  @override
  String gatheringEnded(String emoji, String name) {
    return '$emoji $name terminó';
  }

  @override
  String handedOffStillJoined(String emoji, String name) {
    return 'Pasaste $emoji $name a otra persona y ahora eres participante.';
  }

  @override
  String handedOffNicknameFull(String emoji) {
    return 'Pasaste la reunión a otra persona. Tu nombre ya tiene 10 caracteres, así que agrega $emoji tú mismo para seguir recibiendo avisos.';
  }

  @override
  String handedOffEmojiAdded(String emoji) {
    return 'Pasaste la reunión a otra persona. Agregamos $emoji a tu nombre, así que ahora eres participante.';
  }

  @override
  String get gotIt => 'Entendido';

  @override
  String get blockedToast => 'Esta persona se desvaneció en la oscuridad.';

  @override
  String get unblockedToast =>
      'Desbloqueado. Sus caminos pueden volver a cruzarse.';

  @override
  String notificationToast(String title, String body) {
    return '$title: $body';
  }

  @override
  String get locationServiceOffTitle => 'Activa los Servicios de ubicación';

  @override
  String get locationServiceOffBody =>
      'Mood Whisper necesita saber en qué rincón de la ciudad estás para que las personas cercanas vean tu estado de ánimo. Activa los Servicios de ubicación en la Configuración del teléfono.';

  @override
  String get locationReducedTitle => 'Activa la Ubicación exacta';

  @override
  String get locationReducedBodyIos =>
      'Solo estás compartiendo una ubicación aproximada, así que el radar no puede saber quién está cerca. Ve a Configuración › Mood Whisper › Ubicación y activa Ubicación exacta.';

  @override
  String get locationReducedBodyAndroid =>
      'Solo estás compartiendo una ubicación aproximada, así que el radar no puede saber quién está cerca. Elige Precisa en el permiso de ubicación.';

  @override
  String get locationNoFixTitle => 'Todavía no encontramos tu ubicación';

  @override
  String get locationNoFixBody =>
      'Puede que estés bajo techo o con poca señal. Acércate a una ventana o sal, activa el Wi-Fi e inténtalo de nuevo.';

  @override
  String get locationNeededTitle => 'Mood Whisper necesita tu ubicación';

  @override
  String get locationNeededBody =>
      'Mood Whisper solo usa tu ubicación mientras usas la app, para mostrar estados de ánimo a menos de 5 km. El radar muestra distancias aproximadas, nunca direcciones.\nEn Configuración, permite la ubicación Mientras se usa la app y activa Ubicación exacta.';

  @override
  String get locationSimulatorHint =>
      '(Nota para desarrolladores: en el Simulador, elige una ubicación en Features › Location)';

  @override
  String get openSettings => 'Abrir Configuración';

  @override
  String get locationRecheck => 'Ya lo activé, revisar otra vez';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get leaveApp => 'Salir';

  @override
  String whispersNearby(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hay $count susurros cerca de ti. Toca un sobre para leer uno.',
      one: 'Hay 1 susurro cerca de ti. Toca el sobre para leerlo.',
    );
    return '$_temp0';
  }

  @override
  String get whisperPassed =>
      'Pasaste junto a un susurro. Toca el sobre para leerlo.';

  @override
  String get whisperLeft => 'Tu susurro ya está aquí. Se desvanece en 7 días.';

  @override
  String get timeWhisperSealedYear =>
      'Sellada. Vuelve aquí en un año para abrirla.';

  @override
  String get timeWhisperSealedMonth =>
      'Sellada. Vuelve aquí en un mes para abrirla.';

  @override
  String get whisperWithdrawn => 'Retiraste tu susurro.';

  @override
  String get whisperMineLabel => 'Un susurro que dejaste';

  @override
  String get whisperTapToRead => 'Un susurro. Toca para leer';

  @override
  String get noMoodYet => 'Sin palabras…';

  @override
  String get knockWithdrawnByLeaving =>
      'Volvió a la ciudad y retiró su llamado en silencio…';

  @override
  String get knockCardTitle => 'Un cruce de instantes';

  @override
  String knockCardBody(String name) {
    return '$name está tocando a tu puerta,\ncon la esperanza de que sus caminos se crucen…';
  }

  @override
  String get skip => 'Omitir';

  @override
  String get decline => 'Rechazar';

  @override
  String get accept => 'Aceptar';

  @override
  String get reportThisPerson => 'Denunciar a esta persona';

  @override
  String get cityQuietTonight => 'La ciudad está tranquila esta noche';

  @override
  String cityMoodChip(String mood, String percent) {
    return 'La ciudad hoy · $mood $percent%';
  }

  @override
  String cityMoodChipLabel(String text) {
    return '$text. Ver el clima de ánimo de la ciudad';
  }

  @override
  String get cityMoodTitle => 'El ánimo de la ciudad esta noche';

  @override
  String cityMoodQuietCount(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other:
          'La ciudad todavía está tranquila. $total personas compartieron su ánimo esta noche.',
      one: 'La ciudad todavía está tranquila. 1 persona compartió su ánimo esta noche.',
    );
    return '$_temp0';
  }

  @override
  String cityMoodCount(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other:
          '$total personas a menos de 20 km compartieron su ánimo esta noche',
      one: '1 persona a menos de 20 km compartió su ánimo esta noche',
    );
    return '$_temp0';
  }

  @override
  String get cityMoodQuietInvite =>
      'Cada estado de ánimo suma un poco de luz. Escribe cómo te sientes ahora y ayuda a iluminar la ciudad.';

  @override
  String get cityMoodFootnote =>
      'Estados de ánimo anónimos de las últimas 24 horas. Los porcentajes se ocultan cuando participaron menos de 10 personas.';

  @override
  String get close => 'Cerrar';

  @override
  String get emptyRadarTitle => 'Eres la primera luz de esta noche';

  @override
  String get emptyRadarBody =>
      'Todavía no hay nadie cerca. Tu estado de ánimo ya brilla en la ciudad,\ny quien pase lo verá. También puedes dejar un susurro para la próxima persona que pase.';

  @override
  String emptyRadarCityMood(String total, String mood) {
    return '$total personas están en la ciudad esta noche, y la mayoría se siente “$mood”';
  }

  @override
  String get inviteFriends => 'Invita amigos a iluminar tu barrio';

  @override
  String get shareMoodCard => 'Compartir mi tarjeta de ánimo';

  @override
  String get editYourMood => 'Editar tu estado de ánimo';

  @override
  String resonanceTonight(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count destellos resonaron contigo esta noche',
      one: '1 destello resonó contigo esta noche',
    );
    return '$_temp0';
  }

  @override
  String dockNicknameMood(String nickname) {
    return '$nickname · tu estado de ánimo';
  }

  @override
  String get dockTapToEdit => 'Tu estado de ánimo · toca para editar';

  @override
  String get leaveWhisper => 'Dejar un susurro';

  @override
  String get settings => 'Configuración';

  @override
  String get nightlyReminder => 'Recordatorio nocturno';

  @override
  String get nightlyReminderSubtitle =>
      'Un recordatorio suave a las 21:30 cada noche';

  @override
  String get closeSettings => 'Cerrar configuración';

  @override
  String get settingsSectionMe => 'Yo';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get editProfileSubtitle =>
      'Foto, nombre en la ciudad y estado de ánimo';

  @override
  String get manageBlockList => 'Personas bloqueadas';

  @override
  String get manageBlockListSubtitle =>
      'Mira o desbloquea a quienes enviaste a la oscuridad';

  @override
  String get myTimeWhispers => 'Mis cartas al futuro';

  @override
  String get myTimeWhispersSubtitle =>
      'Notas para tu yo del futuro que solo tú puedes ver';

  @override
  String get myMoodTrail => 'Mi rastro de ánimo';

  @override
  String get myMoodTrailSubtitle => 'Guardado solo en tu teléfono';

  @override
  String get settingsSectionGatherings => 'Reuniones';

  @override
  String get gatheringHost => 'Organizar una reunión';

  @override
  String get gatheringHostSubtitle =>
      'Crea un evento para todos a menos de 5 km de ti';

  @override
  String gatheringHosting(String emoji, String name) {
    return 'Estás organizando $emoji $name';
  }

  @override
  String get settingsSectionShare => 'Compartir';

  @override
  String get shareMoodCardSubtitle =>
      'Una de once ilustraciones nocturnas al azar, hecha para las historias de Instagram';

  @override
  String get inviteFriendsSubtitle =>
      'Cuanta más gente cerca, más brilla la ciudad';

  @override
  String get settingsSectionAbout => 'Acerca de';

  @override
  String get guide => 'Cómo usar';

  @override
  String get guideSubtitle =>
      'Todo, desde escribir tu ánimo hasta organizar una reunión';

  @override
  String get termsOfUse => 'Términos de uso';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get contactUs => 'Contáctanos';

  @override
  String get deleteAccount => 'Eliminar cuenta y datos';

  @override
  String get deleteAccountSubtitle =>
      'Borra para siempre todo lo que dejaste en la ciudad';

  @override
  String get avatarUploadFailed => 'Tu foto no se subió. Inténtalo más tarde.';

  @override
  String get moodEmpty =>
      'Tu estado de ánimo no puede estar vacío. Deja un poco de luz en la ciudad.';

  @override
  String get profileSyncFailed =>
      'No se pudo actualizar tu estado. Inténtalo más tarde.';

  @override
  String get profileUpdated => 'Actualizado. La ciudad siente tu respiración.';

  @override
  String get changeAvatar => 'Cambiar foto';

  @override
  String get avatarHint =>
      'Toca para cambiar tu foto · el anillo es el color de tu ánimo';

  @override
  String get cityName => 'Nombre en la ciudad';

  @override
  String get cityNameHint => 'Opcional, p. ej. Gato Vagabundo';

  @override
  String get currentMood => 'Tu estado de ánimo ahora';

  @override
  String get currentMoodHint => 'p. ej. Caminando bajo una lluvia suave 🌿';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get blockListTitle => 'Enviados a la oscuridad';

  @override
  String get blockListEmpty => 'La noche está despejada. No alejaste a nadie.';

  @override
  String get unblock => 'Desbloquear';

  @override
  String get deleteAccountBody =>
      'Tu ubicación, estado de ánimo, nombre en la ciudad, foto, susurros, destellos, lista de bloqueos y chats abiertos se eliminarán para siempre. No se puede deshacer.\n\nPara evitar abusos, los registros de denuncias se guardan 1 año, como explica la Política de privacidad.';

  @override
  String get deleting => 'Eliminando…';

  @override
  String get deletePermanently => 'Eliminar para siempre';

  @override
  String get deleteFailed =>
      'La eliminación no terminó. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get fadingEcho => 'Eco que se apaga';

  @override
  String clusterCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count estados de ánimo aquí',
      one: '1 estado de ánimo aquí',
    );
    return '$_temp0';
  }

  @override
  String clusterMore(int count) {
    return 'Más\n+$count';
  }

  @override
  String get clusterBackToFirst => 'Volver al\ninicio';

  @override
  String get fadingEchoTitle => 'Un eco que se apaga';

  @override
  String encounterWith(String name) {
    return 'Cruzando caminos con $name';
  }

  @override
  String get fadingEchoBody =>
      'Esto es solo un eco que se apaga. No puedes cruzarte con él.';

  @override
  String get demoPersonBody =>
      'Esta es una persona de demostración que responde automáticamente. No es real. Úsala para probar llamados, chat, destellos, denuncias y bloqueos.';

  @override
  String get sendGlimmer => 'Enviar un destello';

  @override
  String get knock => 'Tocar';

  @override
  String get blockAction => 'Bloquear';

  @override
  String get handOverHost => 'Pasar la organización';

  @override
  String get report => 'Denunciar';

  @override
  String get confirmBlockTitle => '¿Bloquear a esta persona?';

  @override
  String confirmBlockBody(String name) {
    return '¿Enviar a $name a la oscuridad?\nAl bloquear, desaparecen de la ciudad del otro.';
  }

  @override
  String get confirmBlock => 'Bloquear';

  @override
  String get glimmerReceived =>
      'Alguien te envió un destello. Tu estado de ánimo resonó con esa persona.';

  @override
  String get glimmerSent => 'Enviaste un destello.';

  @override
  String get glimmerAlreadySent =>
      'Ya le enviaste un destello hoy. Inténtalo mañana.';

  @override
  String get knockSent => 'Llamado enviado. Esperando respuesta…';

  @override
  String get knockFailed => 'Tu llamado no se envió. Inténtalo más tarde.';

  @override
  String get knockNoAnswer =>
      'Sin respuesta. Tu llamado se desvaneció en silencio.';

  @override
  String get knockDeclined =>
      'Esta vez sus caminos no se cruzaron. Démonos un poco de espacio.';

  @override
  String get knockSkipped =>
      'Lo dejó para después, y tu llamado se desvaneció en silencio.';

  @override
  String get sensingCity => 'Sintiendo la ciudad…';

  @override
  String get sensingCityHint =>
      'Si tu ciudad está muy tranquila ahora, entra al Universo Paralelo o al Mundo Cuántico para conocer gente de otras ciudades.';

  @override
  String get gatheringUnavailable =>
      'Las reuniones no están disponibles ahora. Inténtalo más tarde.';

  @override
  String get notSentCheckNetwork =>
      'No se envió. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get justNow => 'ahora mismo';

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count minutos',
      one: 'hace 1 minuto',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count horas',
      one: 'hace 1 hora',
    );
    return '$_temp0';
  }

  @override
  String get nextDayPrefix => 'día siguiente ';

  @override
  String get gatheringNameMissing => 'Ponle un nombre a tu reunión.';

  @override
  String get gatheringEmojiInvalid =>
      'El ícono de la reunión debe ser exactamente un emoji.';

  @override
  String gatheringStarted(String emoji, String name) {
    return '$emoji $name comenzó. Pide a la gente que agregue $emoji a su nombre en la ciudad para unirse.';
  }

  @override
  String get startGatheringTitle => 'Comenzar una reunión';

  @override
  String get startGatheringLead =>
      'Todos a menos de 5 km de ti. El área se mueve contigo.';

  @override
  String get gatheringNameHint =>
      'Nombre de la reunión, p. ej. Año Nuevo en el Obelisco';

  @override
  String get gatheringEmojiHint => 'Ícono';

  @override
  String get gatheringEmojiHelp =>
      'El ícono de la reunión es un emoji que nadie cerca esté usando.';

  @override
  String gatheringEmojiJoinHelp(String emoji) {
    return 'Quienes agreguen $emoji a su nombre en la ciudad verán tus avisos y recibirán notificaciones.';
  }

  @override
  String get start => 'Inicio';

  @override
  String get end => 'Fin';

  @override
  String get gatheringMaxDuration =>
      'Una reunión dura hasta 24 horas y termina automáticamente.';

  @override
  String get starting => 'Comenzando…';

  @override
  String get startGathering => 'Comenzar reunión';

  @override
  String gatheringEndedYouBack(String emoji, String name) {
    return '$emoji $name terminó. Volviste a la ciudad.';
  }

  @override
  String hostingTimeRange(String range) {
    return '$range · Estás organizando';
  }

  @override
  String hostAudienceRule(String emoji) {
    return 'Las personas a menos de 5 km con $emoji en su nombre ven tus avisos y reciben notificaciones. No puedes ver quiénes son.';
  }

  @override
  String get postAnnouncement => 'Publicar aviso';

  @override
  String get announcementHint =>
      'p. ej. Nos encontramos en la esquina de Corrientes y 9 de Julio';

  @override
  String get announcementSent => 'Aviso enviado';

  @override
  String announcementLine(String ago, String text) {
    return '$ago  $text';
  }

  @override
  String get announcementHiddenSuffix => ' (oculto tras muchas denuncias)';

  @override
  String get groupQuestion => 'Preguntar a todos';

  @override
  String get questionHint => 'p. ej. ¿Cómo están ahora?';

  @override
  String get sendQuestion => 'Preguntar';

  @override
  String get questionSent =>
      'Pregunta enviada. Todos responderán con un estado de ánimo';

  @override
  String get handOff => 'Pasar';

  @override
  String handoffPending(String name) {
    return 'Invitaste a $name a organizar. Esperando respuesta…';
  }

  @override
  String get theOtherPerson => 'esa persona';

  @override
  String get handoffCancelled => 'Invitación cancelada';

  @override
  String get handoffHelp =>
      'En el radar, mantén presionada la burbuja de un participante → Pasar la organización. Cuando acepte, organizará y la reunión seguirá sin interrupción.';

  @override
  String get confirmEndAgain => '¿Terminar? Toca otra vez';

  @override
  String get endGathering => 'Terminar reunión';

  @override
  String tallyHeader(String question, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total respuestas',
      one: '1 respuesta',
    );
    return '“$question” · $_temp0';
  }

  @override
  String get tallyQuiet =>
      'Los porcentajes aparecen después de 10 respuestas, para que nadie pueda ser identificado cuando responden pocos.';

  @override
  String get bannerYouHost => '  · Estás organizando';

  @override
  String get bannerHostAnnouncement => '  · Del anfitrión';

  @override
  String get manageGathering => 'Administrar reunión';

  @override
  String get reportAnnouncement => 'Denunciar este aviso';

  @override
  String get expandAnnouncement => 'Mostrar aviso';

  @override
  String get collapseAnnouncement => 'Ocultar aviso';

  @override
  String hostHandedOffAgo(String ago) {
    return 'Nuevo anfitrión · $ago';
  }

  @override
  String get announcementReportedHidden =>
      'Denunciaste este aviso, así que se quitó de tu pantalla.';

  @override
  String get noAnnouncementHost =>
      'Todavía no hay avisos. Toca los controles arriba a la derecha para publicar el primero.';

  @override
  String get noAnnouncementGuest => 'El anfitrión todavía no publicó nada.';

  @override
  String hostAsks(String question) {
    return 'El anfitrión pregunta: $question';
  }

  @override
  String get answeredNote =>
      'Respondido. El anfitrión solo ve los porcentajes generales de ánimo.';

  @override
  String get answerHint => 'Responde con un estado de ánimo';

  @override
  String get sendAnswer => 'Enviar respuesta';

  @override
  String handoffInvited(String name) {
    return 'Invitaste a $name a organizar. Esperando respuesta (válido por 5 minutos).';
  }

  @override
  String handoffTitle(String name) {
    return 'Pasar la reunión a $name';
  }

  @override
  String get handoffBody =>
      'Cuando acepte, organizará la reunión. El nombre, los avisos y la pregunta se mantienen, y tú pasas a ser participante.';

  @override
  String get handoffPublic => 'Anunciar el cambio';

  @override
  String get handoffPublicHelp =>
      'Avisar a todos los participantes que hay un nuevo anfitrión';

  @override
  String get handoffQuiet => 'Cambio silencioso';

  @override
  String get handoffQuietHelp =>
      'No se avisa a nadie. Solo se mueve el anillo del anfitrión en el radar';

  @override
  String get sending => 'Enviando…';

  @override
  String get sendInvite => 'Enviar invitación';

  @override
  String youAreNowHost(String emoji, String name) {
    return 'Ahora organizas $emoji $name.';
  }

  @override
  String get handoffOfferTitle => '¿Quieres organizar la reunión?';

  @override
  String handoffOfferBody(String name) {
    return 'El anfitrión quiere pasarte “$name”. Como anfitrión puedes publicar avisos, hacer preguntas y terminar la reunión, y eres responsable de lo que publiques.';
  }

  @override
  String get processing => 'Procesando…';

  @override
  String get acceptHosting => 'Aceptar';

  @override
  String get guideS1Title => '1. Entra a la ciudad';

  @override
  String get guideS1L1 =>
      'La primera vez que abras la app, confirma que tienes 18 años o más y permite la ubicación exacta mientras usas la app. Sin ubicación exacta, el radar no funciona.';

  @override
  String get guideS1L2 =>
      'Escribe una frase sobre cómo te sientes ahora (hasta 20 caracteres), acepta los Términos de uso y la Política de privacidad y toca Registrarme aquí y entrar.';

  @override
  String get guideS1L3 =>
      'No necesitas teléfono, correo ni nombre real. Tu cuenta es anónima y está ligada a este teléfono.';

  @override
  String get guideS1L4 =>
      'Las palabras de tu estado de ánimo definen su color: “feliz, reír” es dorado, “triste, llorar” es azul, “enojado” es rojo anaranjado, “tranquilo, soñar” es verde, “con energía” es naranja, “amor, corazón” es rosa, y lo demás es violeta suave.';

  @override
  String get guideS1L5 =>
      'Registro: cada vez que abres la app te registras tú mismo, y solo entonces las personas cercanas ven tu estado de ánimo y más o menos dónde estás, y tú las ves. Nunca ocurre automáticamente. Los demás ven el lugar donde te registraste; no te sigue. Si te alejas más de 1 km, aparece Registrarme aquí debajo del radar. Si la app estuvo en segundo plano más de 30 minutos, te registras de nuevo al volver.';

  @override
  String get guideS2Title => '2. La barra inferior';

  @override
  String get guideS2L1 =>
      'Toca tu foto a la izquierda para editar tu foto, tu nombre en la ciudad (hasta 10 caracteres) y tu estado de ánimo.';

  @override
  String get guideS2L2 => 'Ícono de libreta: deja un susurro justo aquí.';

  @override
  String get guideS2L3 =>
      'Ícono de compartir: convierte tu estado de ánimo en una tarjeta nocturna.';

  @override
  String get guideS2L4 =>
      'Ícono de controles a la derecha: abre la Configuración.';

  @override
  String get guideS3Title => '3. Radar y burbujas';

  @override
  String get guideS3L1 =>
      'En el radar aparecen las burbujas de ánimo de personas a menos de 5 km. Solo se muestra un rango de distancia aproximado (como “a menos de 100 m”), nunca una dirección.';

  @override
  String get guideS3L2 =>
      'Solo aparecen en el radar quienes se registraron y tienen la app abierta. Cuando alguien sale o cambia de app, su burbuja desaparece al instante sin dejar rastro.';

  @override
  String get guideS3L3 =>
      'Pellizca para hacer zoom en el mapa. Gira el teléfono y el radar gira contigo.';

  @override
  String get guideS3L4 =>
      'Cuando las burbujas se amontonan, se unen en una esfera brillante, “N estados de ánimo aquí”. Tócala para abrirlas en círculo y tocar cada una; toca el centro o un espacio vacío para cerrarla.';

  @override
  String get guideS3L5 =>
      'Los nombres que empiezan con Demo son personas de demostración que responden automáticamente. No son reales y puedes usarlas para probar todo.';

  @override
  String get guideS3L6 =>
      'Cuando no hay nadie cerca, abajo aparece “Eres la primera luz de esta noche” y puedes invitar amigos a iluminar tu barrio.';

  @override
  String get guideS4Title => '4. Tocar y chatear';

  @override
  String get guideS4L1 =>
      'Mantén presionada la burbuja de alguien → Tocar. Tiene 5 minutos para aceptar, rechazar u omitir. Mientras esperas, una línea de luz va de ti hacia esa persona.';

  @override
  String get guideS4L2 =>
      'Cuando acepta, empieza un chat con cuenta regresiva de 10 minutos. Cada mensaje nuevo la reinicia, y el chat termina cuando los dos se quedan en silencio.';

  @override
  String get guideS4L3 =>
      'Cuando termina el chat, los mensajes se borran del servidor. La otra persona igual podría hacer capturas, así que comparte con cuidado.';

  @override
  String get guideS4L4 =>
      'Cuando alguien toca tu puerta, aparece una tarjeta de llamado. Puedes aceptar, rechazar, omitir o denunciar al instante.';

  @override
  String get guideS5Title => '5. Destellos';

  @override
  String get guideS5L1 =>
      'Toca dos veces la burbuja de alguien, o mantenla presionada y elige Enviar un destello, para que sepa que alguien lo notó sin decir nada.';

  @override
  String get guideS5L2 =>
      'Solo ve “N destellos resonaron contigo esta noche”, nunca quién los envió. Puedes enviar un destello a la misma persona cada 24 horas.';

  @override
  String get guideS6Title => '6. Susurros';

  @override
  String get guideS6L1 =>
      'Toca el ícono de libreta en la barra inferior para dejar una frase donde estás (hasta 60 caracteres).';

  @override
  String get guideS6L2 =>
      'Durante los próximos 7 días, quien esté a menos de 300 m verá un sobre en el radar y podrá abrirlo.';

  @override
  String get guideS6L3 =>
      'Los susurros siempre son anónimos. Puedes tener hasta 3 a la vez, dejar como máximo 1 cada 10 minutos y retirarlos cuando quieras.';

  @override
  String get guideS6L4 =>
      'Cartas al futuro: al escribir un susurro, elige Para mi yo del futuro y luego un mes o un año. Solo tú puedes verla. Cuando llegue el momento te avisaremos, y se abrirá sola cuando vuelvas a menos de 100 m. Solo se puede leer una vez. Solo tú ves un pequeño reloj de arena en el radar (cerrado o abierto), y no se puede tocar. Puedes tener hasta 5 a la vez; míralas o bórralas en Configuración → Mis cartas al futuro.';

  @override
  String get guideS7Title => '7. Clima de ánimo de la ciudad';

  @override
  String get guideS7L1 =>
      'La etiqueta arriba a la izquierda muestra el estado de ánimo más común a menos de 20 km en las últimas 24 horas. Tócala para ver el detalle.';

  @override
  String get guideS7L2 =>
      'Los porcentajes se ocultan cuando participaron menos de 10 personas, para que nadie pueda ser identificado.';

  @override
  String get guideS8Title => '8. Reuniones';

  @override
  String get guideS8L1 =>
      'Para empezar: Configuración → Organizar una reunión → escribe un nombre, un emoji como ícono y una hora de inicio y fin (hasta 24 horas) → Comenzar reunión.';

  @override
  String get guideS8L2 =>
      'La reunión cubre 5 km alrededor del lugar donde se registró el anfitrión; cuando vuelve a registrarse, se mueve con él. El anfitrión tiene un anillo de luz y la etiqueta Anfitrión en el radar.';

  @override
  String get guideS8L3 =>
      'El anfitrión puede publicar avisos (los que necesite), hacer una pregunta a todos y terminar la reunión cuando quiera.';

  @override
  String get guideS8L4 =>
      'Para unirte, agrega el ícono de la reunión a tu nombre en la ciudad (por ejemplo “Gato Vagabundo🌈”). Mientras estés en el área verás el aviso fijado sobre el radar y recibirás notificaciones. Quita el ícono para salir.';

  @override
  String get guideS8L5 =>
      'Pregunta al grupo: responde con un estado de ánimo. El anfitrión solo ve los porcentajes generales, nunca quién respondió qué, y se ocultan con menos de 10 respuestas.';

  @override
  String get guideS8L6 =>
      'Solo una reunión puede usar un ícono en la misma zona a la vez. Cuando termina, cualquiera puede usarlo.';

  @override
  String get guideS8L7 =>
      'Cambio de anfitrión: el anfitrión mantiene presionada la burbuja de un participante → Pasar la organización, y elige cambio anunciado o silencioso. Si la persona acepta en 5 minutos, pasa a ser anfitriona, y los avisos y la pregunta se mantienen. El anfitrión anterior pasa a ser participante y el ícono se agrega a su nombre.';

  @override
  String get guideS9Title => '9. Faro de la Ciudad (baños accesibles)';

  @override
  String get guideS9L1 =>
      'Toca el ícono de baño abajo a la izquierda del mapa para encender el faro. En el radar aparecen baños inclusivos, accesibles y familiares a menos de 2 km, con un contador junto al ícono. Toca los tres filtros redondos de arriba para ver solo algunos tipos.';

  @override
  String get guideS9L2 =>
      'Toca un marcador para ver el piso, las instalaciones y la distancia, y toca Ir caminando para abrir la ruta en tu app de mapas.';

  @override
  String get guideS9L3 =>
      'Los datos vienen de los registros de baños públicos del Ministerio de Medio Ambiente de Taiwán y se actualizan cada mes. No incluyen horarios; “Probablemente abierto de noche” es nuestra estimación según el tipo de lugar.';

  @override
  String get guideS9L4 =>
      'Si algo está mal, puedes reportarlo (no es inclusivo, cerrado de noche, no lo encuentro). Cuando 3 personas reportan el mismo problema, el marcador se vuelve gris con una nota.';

  @override
  String get guideS10Title => '11. Tarjetas y rastro de ánimo';

  @override
  String get guideS10L1 =>
      'El botón de compartir de la barra inferior convierte tu estado de ánimo actual en una tarjeta nocturna, hecha para las historias de Instagram. La tarjeta nunca muestra tu ubicación.';

  @override
  String get guideS10L2 =>
      'Configuración → Mi rastro de ánimo te deja repasar los estados de ánimo y lugares que escribiste. Se guarda solo en tu teléfono, y puedes desactivarlo o borrarlo cuando quieras.';

  @override
  String get guideS11Title => '17. Configuración y notificaciones';

  @override
  String get guideS11L1 =>
      'Recordatorio nocturno: un recordatorio suave a las 21:30 cada noche. Actívalo o desactívalo en Configuración.';

  @override
  String get guideS11L2 =>
      'Los llamados, mensajes nuevos, destellos y avisos de reuniones llegan como notificaciones. Puedes desactivarlas en la configuración del teléfono.';

  @override
  String get guideS11L3 =>
      'Cada viernes de 21:00 a 23:00 es la Noche de Luz: todos se conectan juntos y la ciudad brilla más.';

  @override
  String get guideS12Title => '18. Denuncias y bloqueos';

  @override
  String get guideS12L1 =>
      'Puedes denunciar desde el menú de una burbuja (mantener presionado), una tarjeta de llamado, arriba a la derecha de un chat, un susurro o un aviso de reunión. Al denunciar, esa persona o publicación desaparece de tu pantalla al instante y el chat termina. Atendemos cada denuncia en menos de 24 horas.';

  @override
  String get guideS12L2 =>
      'Los estados de ánimo, nombres, susurros, mensajes y avisos de reuniones se filtran automáticamente para quitar palabras ofensivas y datos de contacto como teléfonos y enlaces.';

  @override
  String get guideS12L3 =>
      'Al bloquear a alguien, desaparecen del radar del otro y no pueden tocarse la puerta ni enviarse destellos. Desbloquéalo en Configuración → Personas bloqueadas.';

  @override
  String get guideS12L4 =>
      'Si estás en peligro inmediato, llama al número de emergencias local (911 en Argentina).';

  @override
  String get guideS13Title => '19. Privacidad y tu cuenta';

  @override
  String get guideS13L1 =>
      'Solo después de registrarte las personas cercanas ven tu estado de ánimo, nombre en la ciudad, foto y distancia aproximada. Ven el lugar donde te registraste, no tu ubicación en vivo.';

  @override
  String get guideS13L2 =>
      'Configuración → Eliminar cuenta y datos borra para siempre todo lo que dejaste en la ciudad, cuando quieras.';

  @override
  String get guideS13L3 =>
      '¿Preguntas? Ve a Configuración → Contáctanos o escribe a service.softchip@gmail.com.';

  @override
  String get guideS14Title => '12. Universo Paralelo';

  @override
  String get guideS14L1 =>
      'Toca el globo arriba a la derecha del radar para activarlo, y otra vez para desactivarlo. Está apagado cada vez que abres la app.';

  @override
  String get guideS14L2 =>
      'Cada ciudad o condado de Taiwán tiene como centro su estación central (el Gran Taipéi, la Estación de Taipéi; Taoyuan, la Estación de Taoyuan, etc.) y se conecta con ciudades del exterior: Japón, Corea, Hong Kong, Macao, Singapur, Malasia, Indonesia, Vietnam, Tailandia, Filipinas, Australia, Nueva Zelanda, India, Brasil, Argentina y Sudáfrica. Las ciudades del exterior se conectan con Taiwán.';

  @override
  String get guideS14L3 =>
      'La distancia y dirección en que estás de tu estación es donde apareces en la ciudad de la otra persona, a la misma distancia y dirección de su estación, difuminado a unos 500 m. Nadie puede ver tu ubicación real.';

  @override
  String get guideS14L4 =>
      'Se ven si cualquiera de los dos lo tiene activado: activado, ves a todos los que tienen la app abierta en las ciudades conectadas; desactivado, solo ves a quienes lo activaron. Solo aparecen en otras ciudades quienes se registraron y tienen la app abierta.';

  @override
  String get guideS14L5 =>
      'Las personas del Universo Paralelo tienen un anillo punteado y muestran su ciudad. Igual puedes enviar destellos, tocar y chatear. Los susurros, cartas al futuro y reuniones se quedan en el lugar.';

  @override
  String get guideS15Title => '16. Traducción';

  @override
  String get guideS15L1 =>
      'En un chat, cuando un mensaje no está en tu idioma, aparece Toca para traducir debajo. Tócalo para traducirlo a tu idioma, y otra vez para ver el original.';

  @override
  String get guideS15L2 =>
      'Las burbujas de ánimo del radar funcionan igual: si una no está en tu idioma, tócala para traducirla y otra vez para volver al original.';

  @override
  String get guideS15L3 =>
      'La traducción ocurre completamente en tu teléfono; el texto nunca se sube. iPhone usa la traducción integrada de Apple, y el sistema pregunta antes de descargar un idioma la primera vez. Android usa Google ML Kit, que pregunta primero y luego descarga un modelo de unos 30 MB. iPhone todavía no traduce malayo.';

  @override
  String get guideIntro =>
      'Mood Whisper es una ciudad de noche: escribe una frase sobre cómo te sientes ahora y mira cómo se sienten las personas cerca de ti.';

  @override
  String get beaconGender => 'Inclusivo';

  @override
  String get beaconAccessible => 'Accesible';

  @override
  String get beaconFamily => 'Familiar';

  @override
  String get beaconReportNotGender => 'No es inclusivo';

  @override
  String get beaconReportClosed => 'Cerrado de noche';

  @override
  String get beaconReportMissing => 'No encuentro este baño';

  @override
  String get beaconFlagNotGender => 'Reportado: no es inclusivo';

  @override
  String get beaconFlagClosed => 'Reportado: cerrado de noche';

  @override
  String get beaconFlagMissing => 'Reportado: no se encuentra';

  @override
  String get beaconDefaultName => 'Baño público';

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
      'El Faro de la Ciudad no está disponible ahora. Inténtalo más tarde.';

  @override
  String get notConnectedCheckNetwork =>
      'No se pudo conectar. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String beaconMarkerLabel(String features, String name, String distance) {
    return 'Baño $features, $name, $distance';
  }

  @override
  String get listSeparator => ', ';

  @override
  String beaconToggleOff(int count) {
    return 'Apagar el Faro de la Ciudad (baños accesibles), $count cerca';
  }

  @override
  String get beaconToggleOn =>
      'Encender el Faro de la Ciudad (baños accesibles)';

  @override
  String beaconFilterOnly(String feature) {
    return 'Mostrar solo $feature';
  }

  @override
  String get beaconMaybeOpenNight =>
      'Probablemente abierto de noche (estimado)';

  @override
  String get beaconMaybeDaytime => 'Probablemente solo de día (estimado)';

  @override
  String get walkThere => 'Ir caminando';

  @override
  String get beaconWrongData => '¿Algo está mal?';

  @override
  String beaconThanks(String reason) {
    return 'Gracias. Recibimos tu reporte: “$reason”.';
  }

  @override
  String get beaconSource =>
      'Fuente: registros de baños públicos del Ministerio de Medio Ambiente de Taiwán, actualizados cada mes. Los horarios son nuestra estimación según el tipo de lugar.';

  @override
  String get invite1 =>
      'Encendí una luz en Mood Whisper. Cuanta más gente cerca, más brilla nuestro barrio. Ven a encenderla conmigo:';

  @override
  String get invite2 =>
      'La ciudad está un poco tranquila esta noche. Escribe tu ánimo en Mood Whisper y ayuda a que nuestro barrio brille:';

  @override
  String get invite3 =>
      'Sin solicitudes de amistad ni nombres reales, solo una frase sobre cómo te sientes. Búscame en Mood Whisper:';

  @override
  String get invite4 =>
      'Te dejé una luz encendida en Mood Whisper. Abre la app y mira cómo se sienten las personas cerca esta noche:';

  @override
  String get invite5 =>
      'Cada viernes a las 21 h es la Noche de Luz en Mood Whisper. Conéctate conmigo y llenemos el radar de luz:';

  @override
  String get invite6 =>
      '¿Necesitas un lugar para contar cómo te fue hoy? Mood Whisper es anónimo y tus palabras se desvanecen después:';

  @override
  String get invite7 =>
      '¿Alguna vez te preguntaste qué sienten las personas con las que te cruzas? Míralo en Mood Whisper:';

  @override
  String get invite8 =>
      'Dejé un susurro en esta calle que solo pueden leer quienes pasan. Ven a dejar uno tú también:';

  @override
  String get invite9 =>
      'Mood Whisper es un mapa de los estados de ánimo de la ciudad de noche. Con más gente es mejor, así que ven a sumar una luz a nuestro barrio:';

  @override
  String get invite10 =>
      '¿De qué color es tu ánimo esta noche? Escríbelo en Mood Whisper. Estaré cerca, esperando tu luz:';

  @override
  String get shareInvite => 'Compartir invitación';

  @override
  String get inviteSubject => 'Ven a iluminar nuestro barrio conmigo';

  @override
  String get shareMoodCardButton => 'Compartir tarjeta';

  @override
  String moodShareText(String mood) {
    return 'Compartí cómo me siento ahora en Mood Whisper: “$mood”\n¿Tu ánimo también brilla en la ciudad esta noche?';
  }

  @override
  String get shareFailed => 'No se pudo compartir. Inténtalo de nuevo.';

  @override
  String shuffleCard(int current, int total) {
    return 'Cambiar · $current / $total';
  }

  @override
  String get preparing => 'Preparando…';

  @override
  String get sendLinkToFriends =>
      'Enviar enlace a amigos (WhatsApp, Messenger)';

  @override
  String get partLateNight => 'Madrugada';

  @override
  String get partMorning => 'Mañana';

  @override
  String get partAfternoon => 'Tarde';

  @override
  String get partDusk => 'Atardecer';

  @override
  String get partNight => 'Noche';

  @override
  String get cardInviteEyebrow => 'Una invitación';

  @override
  String get cardMoodEyebrow => 'Cómo me siento ahora';

  @override
  String get cardInviteTitle => 'Ven a iluminar\nnuestro barrio';

  @override
  String get cardInviteBody =>
      'Encendí una luz en Mood Whisper.\nCuanta más gente cerca, más brilla nuestro barrio.';

  @override
  String cardMoodFooter(String date, String partOfDay) {
    return '$date · $partOfDay\nEn algún lugar de la ciudad';
  }

  @override
  String get whisperUnavailable =>
      'Los susurros no están disponibles ahora. Inténtalo más tarde.';

  @override
  String get whisperNotSent =>
      'Tu susurro no se envió. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count días',
      one: 'hace 1 día',
    );
    return '$_temp0';
  }

  @override
  String get timeWhisperTitle => 'Carta al futuro';

  @override
  String get timeWhisperLead =>
      'Escríbele a tu yo del futuro. Cuando llegue el momento, vuelve aquí para abrirla.';

  @override
  String get whisperLead => 'Escríbele a la próxima persona que pase.';

  @override
  String get toPassersBy => 'Para quien pase';

  @override
  String get toFutureSelf => 'Para mi yo del futuro';

  @override
  String get inOneMonth => 'En un mes';

  @override
  String get inOneYear => 'En un año';

  @override
  String get timeWhisperHint =>
      'p. ej. Nos vemos aquí el año que viene. Ojalá estés mejor que ahora.';

  @override
  String get whisperHint =>
      'p. ej. El atardecer aquí es hermoso. Acuérdate de mirar hacia arriba.';

  @override
  String get timeWhisperCaptionYear =>
      'Solo tú puedes verla · se abre en un año y te avisa · se abre a menos de 100 m';

  @override
  String get timeWhisperCaptionMonth =>
      'Solo tú puedes verla · se abre en un mes y te avisa · se abre a menos de 100 m';

  @override
  String get whisperCaption =>
      'Se desvanece en 7 días · nunca muestra quién eres · solo que estuviste por aquí';

  @override
  String get sealHere => 'Sellarla aquí';

  @override
  String get leaveHere => 'Dejarlo aquí';

  @override
  String get aWhisper => 'Un susurro';

  @override
  String whisperLeftAgo(String ago) {
    return 'Dejado por aquí $ago';
  }

  @override
  String whisperCollectedBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lo leyeron $count personas',
      one: 'Lo leyó 1 persona',
    );
    return '$_temp0';
  }

  @override
  String get whisperNobodyYet => 'Todavía no pasó nadie';

  @override
  String get withdrawWhisper => 'Retirar este susurro';

  @override
  String get whisperCollected => 'Recogiste este susurro.';

  @override
  String whisperReadersBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count personas pasaron antes que tú.',
      one: '1 persona pasó antes que tú.',
    );
    return '$_temp0';
  }

  @override
  String get whisperFirstReader => 'Eres la primera persona en pasar.';

  @override
  String get reportWhisper => 'Denunciar este susurro';

  @override
  String get thisWhisper => 'Este susurro';

  @override
  String get chatTimeUp => 'Se acabó el tiempo. El instante se desvanece...';

  @override
  String get chatOtherLeft => 'Volvió a la ciudad...';

  @override
  String get chatEnded => 'Este instante terminó...';

  @override
  String get chatBlockedEnded => 'Bloqueado. La conversación terminó.';

  @override
  String get chatReportedEnded => 'Denunciado. La conversación terminó.';

  @override
  String get anonymous => 'Anónimo';

  @override
  String get leaveChat => 'Salir de la conversación';

  @override
  String chatWith(String name) {
    return 'Un instante con $name';
  }

  @override
  String get countdownPrefix => 'Se desvanece en ';

  @override
  String get countdownSuffix => '';

  @override
  String get demoChatNotice =>
      'Conversación de demostración: las respuestas son automáticas, no de una persona real.';

  @override
  String get typing => 'Escribiendo…';

  @override
  String get chatHint => 'Di algo en voz baja…';

  @override
  String get send => 'Enviar';

  @override
  String get chatDissolvedApart => 'Cada uno volvió a la ciudad';

  @override
  String get knockTooOften =>
      'Estás tocando demasiado. Respira con la ciudad...';

  @override
  String get otherNotNow =>
      'Prefiere que no la molesten ahora. Dense un poco de espacio.';

  @override
  String otherNotNowMinutes(int minutes) {
    return 'Prefiere que no la molesten ahora. Dense un poco de espacio ($minutes min).';
  }

  @override
  String get justEndedRest =>
      'Acaban de despedirse. Deja que el recuerdo se asiente un rato.';

  @override
  String get intro1Title => 'Entra a la ciudad';

  @override
  String get intro1Body =>
      'Deja atrás las etiquetas sociales. En un lienzo oscuro y silencioso, solo queda cómo te sientes de verdad, y dónde.';

  @override
  String get intro2Title => 'Un instante fugaz';

  @override
  String get intro2Body =>
      '¿Ves una burbuja de ánimo flotando cerca? Toca suavemente y comparte una conversación única con alguien que pasa.';

  @override
  String get intro3Title => 'El ritmo de la ciudad';

  @override
  String get intro3Body =>
      'Nos importa cómo te sientes. Después de tocar, espera la respuesta en silencio. Si no tiene que ser, la burbuja se desvanece a los 300 segundos.';

  @override
  String get intro4Title => 'Una distancia amable';

  @override
  String get intro4Body =>
      '¿No quieres que te molesten? Rechaza o bloquea. Un sistema de pausa aleja el ruido y te devuelve tu rincón tranquilo.';

  @override
  String get intro5Title => '¿Listo para encontrarte?';

  @override
  String get intro5Body =>
      'Cierra los ojos y siente el pulso de tu teléfono y tu corazón. Ahora escribe cómo te sientes, regístrate aquí y entra a Mood Whisper.';

  @override
  String get intro6Title => 'Una carta a tu yo del futuro';

  @override
  String get intro6Body =>
      'Deja unas palabras en este mismo lugar para ti dentro de un mes o un año. Solo se abre cuando vuelvas.';

  @override
  String get intro7Title => 'Brillen juntos esta noche';

  @override
  String get intro7Body =>
      'Organiza una reunión con un emoji como seña secreta. Todos los que lo agreguen a su nombre reciben tus avisos, y todo el barrio se ilumina junto.';

  @override
  String get intro8Title => 'Universo Paralelo';

  @override
  String get intro8Body =>
      'Toca el globo y las ciudades de Taiwán se superponen con Tokio, Seúl, São Paulo y Buenos Aires. Mira cómo se sienten personas lejanas ahora, toca, chatea y traduce con un toque.';

  @override
  String get loadingImage => 'Cargando imagen...';

  @override
  String get startExploring => 'Empezar a explorar';

  @override
  String get nextPage => 'Siguiente';

  @override
  String get feedbackSubject => 'Comentarios sobre Mood Whisper';

  @override
  String get loginNeedMood =>
      'Escribe cómo te sientes ahora y entra a la ciudad.';

  @override
  String get loginNeedAgree =>
      'Primero lee y acepta los Términos de uso y la Política de privacidad.';

  @override
  String get loginCantConnect =>
      'No pudimos llegar a la ciudad. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get ageQuestion => '¿Tienes 18 años o más?';

  @override
  String get ageReason =>
      'Mood Whisper te conecta con desconocidos cercanos, así que es solo para mayores de 18 años.';

  @override
  String get ageUnder => 'Tengo menos de 18';

  @override
  String get ageOver => 'Tengo 18 o más';

  @override
  String get loginTitle1 => '¿Listo';

  @override
  String get loginTitle2 => ' para encontrarte?';

  @override
  String get loginLead =>
      'Cierra los ojos y siente el pulso de tu teléfono y tu corazón.\nAhora escribe cómo te sientes y entra a Mood Whisper.';

  @override
  String get loginPrompt => '¿Qué quieres decirle a la ciudad ahora?';

  @override
  String get loginHint => 'p. ej. Me tomé un café buenísimo😊';

  @override
  String get enterCity => 'Entrar a Mood Whisper';

  @override
  String get agreeSemantic =>
      'Leí y acepto los Términos de uso y la Política de privacidad';

  @override
  String get agreePrefix => 'Leí y acepto los ';

  @override
  String get termsLink => 'Términos de uso';

  @override
  String get agreeAnd => ' y la ';

  @override
  String get privacyLink => 'Política de privacidad';

  @override
  String get agreeSuffix =>
      '. Mood Whisper tiene tolerancia cero con el acoso, el contenido sexual, el odio u otros abusos. Quien rompa esta regla será eliminado.';

  @override
  String get under18Title => 'Mood Whisper es para mayores de 18 años';

  @override
  String get under18Body =>
      'Gracias por tu sinceridad. Esta ciudad te conecta con desconocidos. Nos vemos cuando cumplas 18.';

  @override
  String get clearMoodTrail => 'Borrar rastro de ánimo';

  @override
  String get clearMoodTrailBody =>
      'Se borrará todo el rastro de ánimo de este teléfono. No se puede deshacer.';

  @override
  String get clear => 'Borrar';

  @override
  String monthDay(int month, int day) {
    return '$day/$month';
  }

  @override
  String get moodTrailLocalOnly =>
      'Guardado solo en tu teléfono. Nunca se sube a ningún lado.';

  @override
  String get moodTrailEmpty =>
      'Todavía no hay rastro de ánimo esta semana. Cada vez que escribas tu ánimo o vayas a un lugar nuevo, aparecerá otra luz aquí.';

  @override
  String get thisWeekYou => 'Tu semana';

  @override
  String get topMoodPrefix => 'Lo que más sentiste fue “';

  @override
  String topMoodSuffix(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '”, $count veces',
      one: '”, 1 vez',
    );
    return '$_temp0';
  }

  @override
  String weekPlacesMoods(int places, int total) {
    return '$total estados de ánimo en $places lugares distintos';
  }

  @override
  String get recordMoodTrail => 'Guardar mi rastro de ánimo';

  @override
  String get recordMoodTrailOff =>
      'Desactivado, no se guarda ningún rastro nuevo';

  @override
  String get nightly1 => '¿Qué siente la ciudad esta noche?';

  @override
  String get nightly2 => 'Alguien cerca está escribiendo cómo se siente ahora.';

  @override
  String get nightly3 =>
      'La noche está perfecta. Deja una frase para la ciudad.';

  @override
  String get nightly4 => '¿Cómo te fue hoy? Tu ánimo brillará en la ciudad.';

  @override
  String get nightly5 =>
      'Se encendieron las luces de la calle, y la gente cerca sigue despierta.';

  @override
  String get nightly6 => 'Dale un final al día: ¿cómo te sientes ahora?';

  @override
  String get nightly7 => '¿Con quién te cruzarás esta noche?';

  @override
  String get nightlyChannel => 'Recordatorio nocturno';

  @override
  String get nightlyChannelDesc =>
      'Un recordatorio suave cada noche. Puedes desactivarlo en la configuración de la app.';

  @override
  String get reasonHarassment => 'Acoso o bullying';

  @override
  String get reasonSexual => 'Contenido sexual';

  @override
  String get reasonScam => 'Estafa o spam';

  @override
  String get reasonHate => 'Odio o violencia';

  @override
  String get reasonImpersonation => 'Suplantación de identidad';

  @override
  String get reasonOther => 'Otro motivo';

  @override
  String get reportReceived =>
      'Denuncia recibida y quitada de tu pantalla. La revisaremos en menos de 24 horas.';

  @override
  String get reportNotSent =>
      'Tu denuncia no se envió. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String reportTarget(String target) {
    return 'Denunciar $target';
  }

  @override
  String get reportPrivate => 'No sabrá que lo denunciaste. Elige un motivo:';

  @override
  String get reportDetails => 'Más detalles (opcional)';

  @override
  String get reportWhatHappened => '¿Qué pasó?';

  @override
  String get sendReport => 'Enviar denuncia';

  @override
  String get alsoBlock =>
      'Bloquear también. Desaparecerán de la ciudad del otro.';

  @override
  String get aYearAgo => 'Hace un año';

  @override
  String get aMonthAgo => 'Hace un mes';

  @override
  String get timeWhisperUnavailable =>
      'Las cartas al futuro no están disponibles ahora. Inténtalo más tarde.';

  @override
  String timeWhisperYouSaid(String ago) {
    return '$ago, dijiste aquí';
  }

  @override
  String writtenOn(String date) {
    return 'Escrita el $date';
  }

  @override
  String get timeWhisperOnce => 'Esta carta aparece solo una vez.';

  @override
  String get keepInHeart => 'Guardarla en el corazón';

  @override
  String unsealsOn(String unlock, String created) {
    return 'Se abre el $unlock · escrita el $created';
  }

  @override
  String get unsealedGoBack => 'Disponible. Vuelve allí para abrirla.';

  @override
  String unsealedDistance(String distance) {
    return 'Disponible · a $distance';
  }

  @override
  String get timeWhisperListLead =>
      'Cartas a tu yo del futuro que solo tú puedes ver. Cuando llegue el momento, acércate a menos de 100 m del lugar para abrir una. Después de leerla, desaparece.';

  @override
  String get timeWhisperListEmpty =>
      'Todavía no hay cartas al futuro. Toca el ícono de nota en la barra inferior y elige “Para mi yo del futuro”.';

  @override
  String get readyToOpen => 'Lista para abrir';

  @override
  String get sealed => 'Sellada';

  @override
  String get delete => 'Eliminar';

  @override
  String get within100m => 'A menos de 100 m';

  @override
  String knockWaitingSemantic(String name, String mm, String ss) {
    return 'Esperando que $name responda, quedan $mm:$ss';
  }

  @override
  String knockWaiting(String name) {
    return 'Esperando a $name';
  }

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Igual que el teléfono';

  @override
  String get parallelUniverse => 'Universo Paralelo';

  @override
  String get parallelUniverseSubtitle =>
      'Mira cómo se sienten otras ciudades ahora y deja que te vean';

  @override
  String get parallelUniverseIntroTitle => 'Entra al Universo Paralelo';

  @override
  String get parallelUniverseIntroBody =>
      'Cuando está activado, todos los que tienen la app abierta en tus ciudades conectadas aparecen en tu radar, y todos pueden verte. Las ciudades de Taiwán se conectan con ciudades del exterior (como Tokio, Seúl y Buenos Aires), y las del exterior se conectan con Taiwán.\n\nLas dos ciudades se alinean por su centro (la estación central, o la municipalidad donde no hay estación): la distancia y dirección en que estás de tu centro es donde apareces en la otra ciudad, difuminado a unos 500 m, así que nadie puede ver tu ubicación ni tu distancia real. Igual puedes enviar destellos, tocar y chatear, y desactivarlo cuando quieras. Los susurros y las reuniones se quedan en el lugar.';

  @override
  String get parallelUniverseEnter => 'Entrar';

  @override
  String get parallelUniverseNoCity =>
      'Todavía no hay Universo Paralelo donde estás';

  @override
  String parallelFrom(String city) {
    return 'Paralelo · $city';
  }

  @override
  String parallelPersonBody(String city) {
    return 'Esta persona está en $city, no cerca de ti. Su posición es proyectada y no muestra una distancia real.';
  }

  @override
  String get labelHost => 'Anfitrión';

  @override
  String get labelDemo => 'Demo';

  @override
  String get labelResting => 'Descansando';

  @override
  String get cityTaipei => 'Taipéi';

  @override
  String get cityTaichung => 'Taichung';

  @override
  String get cityKaohsiung => 'Kaohsiung';

  @override
  String get cityTokyo => 'Tokio';

  @override
  String get cityOsaka => 'Osaka';

  @override
  String get citySeoul => 'Seúl';

  @override
  String get cityBusan => 'Busan';

  @override
  String get cityHongkong => 'Hong Kong';

  @override
  String get cityMacau => 'Macao';

  @override
  String get citySingapore => 'Singapur';

  @override
  String get cityKualalumpur => 'Kuala Lumpur';

  @override
  String get cityJakarta => 'Yakarta';

  @override
  String get cityHochiminh => 'Ciudad Ho Chi Minh';

  @override
  String get cityHanoi => 'Hanói';

  @override
  String get translateTap => 'Toca para traducir';

  @override
  String get translateShowOriginal => 'Traducido · toca para ver el original';

  @override
  String get translating => 'Traduciendo…';

  @override
  String get translateFailed => 'No se pudo traducir. Inténtalo más tarde.';

  @override
  String get translateDownloadTitle => 'Descargar modelo de traducción';

  @override
  String get translateDownloadBody =>
      'Para traducir este idioma por primera vez se necesita un modelo de traducción (unos 30 MB por idioma, se descarga una vez).\n\nLa traducción ocurre completamente en tu teléfono; los mensajes nunca se suben.';

  @override
  String get translateDownload => 'Descargar';

  @override
  String placeHint(String name) {
    return 'Hay una luz de Lugar de Ánimo cerca · $name';
  }

  @override
  String placeOpenUntil(String time) {
    return 'Abierto hasta las $time';
  }

  @override
  String placeLampLabel(String name, String hours) {
    return 'Lugar de Ánimo: $name, $hours';
  }

  @override
  String get placeWrongData => '¿Algo está mal?';

  @override
  String placeReportSubject(String name) {
    return 'Información incorrecta de un Lugar de Ánimo: $name';
  }

  @override
  String get placeHintsSetting => 'Avisos de Lugares de Ánimo';

  @override
  String get placeHintsSettingSubtitle =>
      'Un aviso discreto en la app cuando pasas por un Lugar de Ánimo abierto (sin notificaciones push)';

  @override
  String get guideS16Title => '10. Lugares de Ánimo';

  @override
  String get guideS16L1 =>
      'Los Lugares de Ánimo son cafés independientes asociados. Después de registrarte, acércate a menos de 150 m de uno mientras está abierto y aparecerá una pequeña luz en tu radar, respirando despacio. Se apaga cuando te alejas.';

  @override
  String get guideS16L2 =>
      'Toca la luz para abrir la tarjeta del lugar: una vista nocturna desde adentro, el horario de cierre de hoy, una historia de ánimo del café en una línea (toca para traducir), la dirección y el teléfono. Toca Ir caminando para ver la ruta en tu app de mapas. La luz cuya tarjeta abriste hoy brilla suave, sin respirar.';

  @override
  String get guideS16L3 =>
      'La primera vez que pasas, una pequeña tarjeta arriba te avisa, sin sonido ni vibración. Recibes como máximo un aviso por lugar cada 7 días y 2 avisos por día. Desactívalos en Configuración > Avisos de Lugares de Ánimo; las luces siguen.';

  @override
  String get guideS16L4 =>
      'La lista completa de lugares se descarga en tu teléfono, y si estás cerca se calcula solo en tu teléfono. Ni nosotros ni los cafés sabemos por dónde pasas. Los cafés no pueden pagar por visibilidad. Si algo está mal, repórtalo al final de la tarjeta.';

  @override
  String get placeGuestbook => 'Libro de visitas';

  @override
  String placeGuestbookLocked(int m) {
    return 'Entra al local (a unos $m m) para leer lo que dejaron quienes se sentaron aquí antes.';
  }

  @override
  String get placeGuestbookAbout =>
      'Solo pueden leerlo quienes están adentro. Anónimo, desaparece a los 30 días.';

  @override
  String get placeGuestbookEmpty => 'Todavía no hay notas. Deja la primera.';

  @override
  String get placeGuestbookWrite => 'Dejar una nota';

  @override
  String get placeGuestbookHint =>
      'Para la próxima persona que se siente aquí…';

  @override
  String get placeGuestbookSent => 'Listo. La próxima persona aquí la leerá.';

  @override
  String get placeGuestbookUnavailable =>
      'El libro de visitas no está disponible ahora. Inténtalo más tarde.';

  @override
  String get placeNoteMine => 'Tu nota';

  @override
  String get withdrawPlaceNote => 'Retirar esta nota';

  @override
  String get reportPlaceNote => 'Denunciar esta nota';

  @override
  String get thisPlaceNote => 'esta nota';

  @override
  String get guideS16L5 =>
      'Libro de visitas: abre la tarjeta de un lugar mientras estás adentro (a unos 40 m) para leer lo que dejaron quienes se sentaron ahí antes, y deja una línea para la próxima persona. Las notas son anónimas y desaparecen a los 30 días. Puedes dejar una nota por lugar por día, tocar una nota para traducirla y denunciar lo que te moleste. Al abrir el libro, tu teléfono envía tu ubicación a nuestro servidor para confirmar que estás adentro; el servidor no la guarda.';

  @override
  String get quantumWorld => 'Mundo Cuántico';

  @override
  String get quantumWorldSubtitle =>
      'Una sala para todo el mundo, sin revelar dónde estás';

  @override
  String get quantumIntroTitle => 'Entra al Mundo Cuántico';

  @override
  String get quantumIntroBody =>
      'Todos los que están en el Mundo Cuántico ahora comparten una sala, ordenada como una colmena alrededor del Taipei 101. Recibes un asiento como \"Q4-17\": cuanto menor el anillo, más cerca del origen.\n\nNadie puede ver tu ubicación real. Los demás solo ven tu asiento, fijado en el momento en que tocas Entrar; no se mueve cuando caminas. Para cambiarlo, sal y vuelve a entrar. Tu apodo y estado de ánimo siguen igual, y puedes enviar destellos, tocar y chatear, con traducción al toque.\n\nMientras estás en el Mundo Cuántico sales temporalmente del radar normal y del Universo Paralelo; al salir, vuelves al lugar donde te registraste.';

  @override
  String get quantumEnter => 'Entrar';

  @override
  String get quantumLeave => 'Salir del Mundo Cuántico';

  @override
  String get quantumLeft => 'Saliste del Mundo Cuántico y volviste a tu radar';

  @override
  String quantumYourSeat(String code) {
    return 'Tu asiento $code';
  }

  @override
  String quantumSeatHint(int ring) {
    return 'Anillo $ring · los anillos menores están más cerca del origen en el Taipei 101';
  }

  @override
  String quantumOnlineChip(int count) {
    return '$count aquí ahora';
  }

  @override
  String quantumOnlineTitle(int count) {
    return '$count personas en el Mundo Cuántico ahora';
  }

  @override
  String get quantumRegionTw => 'Taiwán';

  @override
  String get quantumRegionJp => 'Japón';

  @override
  String get quantumRegionKr => 'Corea';

  @override
  String get quantumRegionHkmo => 'Hong Kong y Macao';

  @override
  String get quantumRegionSea => 'Sudeste Asiático';

  @override
  String get quantumRegionOther => 'Otros lugares';

  @override
  String get quantumQuiet => 'Silencio Cuántico';

  @override
  String get quantumQuietSubtitle =>
      'Solo mira el mundo: nadie puede tocar, pero los destellos siguen llegando';

  @override
  String get quantumQuietTarget =>
      'Activó el Silencio Cuántico: ahora solo puedes enviarle un destello';

  @override
  String get quantumClosedRegion =>
      'El Mundo Cuántico no está disponible donde estás';

  @override
  String get quantumLeftClosed =>
      'Entraste en una zona donde el Mundo Cuántico no está disponible, así que saliste';

  @override
  String get quantumSeatExpired =>
      'Estuviste fuera demasiado tiempo y tu asiento se liberó; volviste a tu radar';

  @override
  String get quantumUnavailable =>
      'No se puede llegar al Mundo Cuántico ahora. Inténtalo más tarde.';

  @override
  String quantumPersonBody(String code) {
    return 'El asiento de esta persona en el Mundo Cuántico es $code. En el Mundo Cuántico no se muestra la ubicación real de nadie.';
  }

  @override
  String quantumChatTag(String code) {
    return 'Mundo Cuántico · $code';
  }

  @override
  String get guideS17Title => '13. Mundo Cuántico';

  @override
  String get guideS17L1 =>
      'Toca el ícono de colmena arriba a la derecha del radar (debajo del Universo Paralelo), lee la nota y toca Entrar. Entras tocando cada vez, como al registrarte; cada vez que abres la app empiezas en el radar normal.';

  @override
  String get guideS17L2 =>
      'Todos en el Mundo Cuántico comparten una sala: una colmena alrededor del Taipei 101, con asientos a 100 m entre sí. Recibes un código como \"Q4-17\" (anillo 4, asiento 17): los anillos menores están más cerca del origen. Los recién llegados ocupan primero los asientos que otros dejaron; los anillos 1 a 3 están reservados para anfitriones de reuniones.';

  @override
  String get guideS17L3 =>
      'Nadie puede ver tu ubicación real: los demás solo ven tu asiento. Cada vez que tocas Entrar cuenta como un registro, y tu asiento queda fijo desde ese momento; no se mueve cuando caminas. Para cambiarlo, sal y vuelve a entrar. El Mundo Cuántico no está disponible en China continental.';

  @override
  String get guideS17L4 =>
      'Tu apodo y estado de ánimo siguen igual, y puedes enviar destellos, tocar y chatear, con traducción al toque. Separa los dedos para ver toda la colmena; las personas lejanas se ven como puntos de luz. Toca el código de tu asiento arriba a la izquierda para ver quién está conectado, activar el Silencio Cuántico (sin llamados, los destellos siguen llegando) o salir.';

  @override
  String get guideS17L5 =>
      'En el Mundo Cuántico no hay susurros, cartas al futuro, Lugares de Ánimo, Faro de la Ciudad ni reuniones comunes. Mientras estás adentro sales temporalmente del radar normal y del Universo Paralelo; al salir, tu burbuja se disuelve en luz y vuelves al lugar donde te registraste. Si la app está cerrada o sin conexión más de 3 minutos, tu asiento se libera.';

  @override
  String quantumChimeCountdown(int seconds) {
    return 'Campanada de la hora en $seconds s';
  }

  @override
  String get quantumChimeLookOrigin => 'Todos miran el origen en el 101';

  @override
  String get quantumChimeLook => 'Mirar';

  @override
  String quantumChimeNow(int hour) {
    return 'Campanada de las $hour en el Centro Cuántico';
  }

  @override
  String get quantumChimeSend => 'Enviar un destello de campanada';

  @override
  String get quantumChimeSent => 'Tu destello vuela hacia el origen';

  @override
  String quantumChimeWatched(int n) {
    return '$n personas vieron juntas esta campanada';
  }

  @override
  String get quantumChimeReminder => 'Recordatorio de campanada';

  @override
  String get quantumChimeReminderSubtitle =>
      'Un aviso justo antes de cada hora para ver la campanada en el origen del 101';

  @override
  String get quantumChimeNotifyBody =>
      'La campanada de la hora está por empezar: ven a verla en el origen del 101';

  @override
  String get quantumChimeChannel => 'Campanada de la hora';

  @override
  String get quantumChimeChannelDesc =>
      'Recordatorios de la campanada de cada hora en el Mundo Cuántico';

  @override
  String get quantumEntangleInvite => 'Invitar a entrelazarse';

  @override
  String quantumEntangleInvited(String name) {
    return 'Invitaste a $name a entrelazarse';
  }

  @override
  String get quantumEntangleAskTitle => 'Entrelazamiento cuántico';

  @override
  String quantumEntangleAskBody(String name, String code) {
    return '$name ($code) quiere entrelazarse contigo. Una fina línea de luz unirá sus burbujas, visible por lejos que estén. Colapsa cuando cualquiera de los dos sale, y no se guarda nada.';
  }

  @override
  String get quantumEntangleAccept => 'Entrelazarse';

  @override
  String quantumEntangled(String name) {
    return 'Tú y $name están entrelazados';
  }

  @override
  String quantumEntangleCollapsed(String name) {
    return 'Tu entrelazamiento con $name colapsó';
  }

  @override
  String get quantumEntangleCut => 'Desentrelazar';

  @override
  String get quantumEntangleFull => 'Ya estás entrelazado con 3 personas';

  @override
  String get quantumEntangleTheirFull => 'Ya está entrelazado con 3 personas';

  @override
  String get quantumEntangleGone => 'Salió del Mundo Cuántico';

  @override
  String get quantumEntangleExpired => 'La invitación venció';

  @override
  String get quantumEntangledTitle => 'Entrelazados';

  @override
  String get quantumTunnel => 'Túnel cuántico';

  @override
  String get quantumTunnelSubtitle =>
      'Salta a un asiento vacío al azar de la colmena y conoce vecinos nuevos. Una vez por visita.';

  @override
  String get quantumTunnelUsed => 'Ya usaste el túnel en esta visita';

  @override
  String quantumTunnelDone(String code) {
    return 'Saltaste a $code';
  }

  @override
  String get quantumShowTime => 'Mostrar mi hora local';

  @override
  String get quantumShowTimeSubtitle =>
      'Los demás la ven al mantener presionada tu burbuja. Desactivado, solo se ve el tono de día o noche.';

  @override
  String quantumLocalTime(String time, String part) {
    return 'Local $time · $part';
  }

  @override
  String get quantumDawn => 'madrugada';

  @override
  String get quantumDay => 'de día';

  @override
  String get quantumDusk => 'atardecer';

  @override
  String get quantumNight => 'de noche';

  @override
  String get quantumTopicsTitle => 'Sintonía cuántica';

  @override
  String get quantumTopicsSubtitle =>
      'Elige hasta 3 temas para mostrar debajo de tu burbuja';

  @override
  String get quantumTopicMusic => 'Música';

  @override
  String get quantumTopicMovies => 'Películas';

  @override
  String get quantumTopicTech => 'Tecnología';

  @override
  String get quantumTopicWalks => 'Caminatas';

  @override
  String get quantumTopicFood => 'Comida';

  @override
  String get quantumTopicTravel => 'Viajes';

  @override
  String get quantumTopicReading => 'Lectura';

  @override
  String get quantumTopicSports => 'Deportes';

  @override
  String quantumTopicsCommon(String topics) {
    return 'A los dos les gusta: $topics';
  }

  @override
  String get quantumSignalsTitle => 'Señales cuánticas';

  @override
  String quantumSignalReceived(String name) {
    return '$name te envió una señal';
  }

  @override
  String get quantumSignalWait =>
      'Acabas de enviar una; inténtalo en un momento';

  @override
  String quantumResonance(String name) {
    return 'Tú y $name están en resonancia';
  }

  @override
  String get guideS17L6 =>
      'Campanada de la hora: un minuto antes de cada hora, el haz del 101 se ilumina. A la hora en punto, mensajeros de luz rodean el origen, la campana marca la hora del Centro Cuántico (24 campanadas a medianoche) y una última ola de luz recorre la colmena. Toca “Enviar un destello de campanada” durante la campanada: cuanta más gente mirando, más brillante. El recordatorio de campanada viene activado; puedes desactivarlo en el panel.';

  @override
  String get guideS17L7 =>
      'Después de chatear, puedes invitar a alguien a entrelazarse: una línea de luz une sus burbujas por lejos que estén y colapsa cuando uno de los dos sale (hasta 3 a la vez). El túnel cuántico, una vez por visita, te lleva a un asiento vacío al azar con vecinos nuevos.';

  @override
  String get guideS17L8 =>
      'Cada burbuja lleva el tono de la hora local de su dueño: dorado pálido de madrugada, blanco brillante de día, naranja violeta al atardecer, azul profundo de noche. Activa “Mostrar mi hora local” para que los demás vean la hora al mantener presionada tu burbuja. Intercambiar destellos en 24 horas crea resonancia; mantén presionada una burbuja para enviar una señal 👋 ☕ 🌙 🎵 🌧️ ✨; elige hasta 3 temas de sintonía en el panel y los compartidos se encienden.';

  @override
  String get quantumNyTitle => 'Año Nuevo Cuántico';

  @override
  String quantumNyDays(int n) {
    return 'Faltan $n días: a la medianoche del Centro Cuántico el 31/12, haz la cuenta regresiva con el mundo en el origen del 101';
  }

  @override
  String get quantumNyTonight =>
      'Esta noche, a la medianoche del Centro Cuántico, haz la cuenta regresiva con el mundo en el origen del 101';

  @override
  String quantumNyZone(String places) {
    return '¡Feliz Año Nuevo, $places! 🎆';
  }

  @override
  String quantumNyTogether(int n) {
    return '$n personas de todo el mundo recibieron juntas el año nuevo en el Mundo Cuántico';
  }

  @override
  String get quantumNyHappy => 'Feliz Año Nuevo';

  @override
  String get guideS17L9 =>
      'Año Nuevo Cuántico: el 31/12, a medida que cada huso horario llega a la medianoche, sus burbujas se encienden con anillos dorados en oleadas, y los puntos de la vista mundial también se vuelven dorados. A la medianoche del Centro Cuántico, toda la colmena cuenta los últimos 10 segundos, el origen del 101 lanza la mayor explosión de luz del mundo y 5 minutos de fuegos artificiales, y ves cuántas personas entraron juntas al año nuevo.';

  @override
  String get quantumMeetAction => 'Hacer una tarjeta de Encuentro Cuántico';

  @override
  String quantumMeetAsked(String name) {
    return 'Invitaste a $name a hacer juntos una tarjeta de Encuentro Cuántico';
  }

  @override
  String get quantumMeetWait => 'Acabas de pedirlo; inténtalo en un momento';

  @override
  String get quantumMeetAskTitle => 'Tarjeta de Encuentro Cuántico';

  @override
  String quantumMeetAskBody(String name, String code) {
    return '$name (⬡ $code) quiere convertir este encuentro en una tarjeta para compartir. Muestra los apodos, códigos de asiento, horas locales y estados de ánimo de los dos, nunca una ubicación.';
  }

  @override
  String get quantumMeetAccept => 'Hacerla juntos';

  @override
  String get quantumMeetEyebrow => 'ENCUENTRO CUÁNTICO';

  @override
  String get quantumMeetFooter => 'Nos conocimos en el Mundo Cuántico';

  @override
  String get quantumMeetShare => 'Compartir tarjeta';

  @override
  String quantumMeetShareText(String a, String b) {
    return '$a × $b: nos conocimos en el Mundo Cuántico ✨';
  }

  @override
  String get guideS17L10 =>
      'Tarjeta de Encuentro Cuántico: después de chatear, mantén presionada la burbuja de la otra persona para invitarla a hacer una juntos. Cuando los dos aceptan, cada uno recibe una tarjeta para compartir con ambos apodos, códigos de asiento, horas locales con su tono de día o noche y estados de ánimo, nunca una ubicación. Los códigos de asiento del anillo 4 brillan en dorado.';

  @override
  String get quantumOrbEntry => 'Avatar cuántico';

  @override
  String get quantumOrbEntrySubtitle =>
      'Tu foto se convierte en una esfera de cristal en el Mundo Cuántico';

  @override
  String get orbTitle => 'Avatar cuántico';

  @override
  String get orbSubtitle =>
      'El cristal y el brillo siempre siguen tu estado de ánimo';

  @override
  String get orbStyleGlow => 'Brillo';

  @override
  String get orbStyleRing => 'Anillo';

  @override
  String get orbStyleRainbow => 'Arcoíris';

  @override
  String get orbFree => 'Gratis';

  @override
  String get orbOwned => 'Tuya';

  @override
  String get orbInUse => 'En uso';

  @override
  String get orbCosmeticNote =>
      'Las esferas especiales son solo un aspecto: no cambian ninguna función ni privilegio. Las esferas que compras quedan en tu cuenta.';

  @override
  String get orbRestore => 'Restaurar compras';

  @override
  String orbPurchased(String name) {
    return '¡$name es tuya! ✨';
  }

  @override
  String get orbPurchaseFailed =>
      'La compra no se completó. Inténtalo más tarde.';

  @override
  String get orbOwnedElsewhere => 'Esta compra ya se usa en otra cuenta';

  @override
  String get orbStoreUnavailable =>
      'No se puede acceder a la tienda ahora. Inténtalo más tarde.';

  @override
  String get aiyaName => 'AIYA';

  @override
  String get aiyaChip => 'AIYA · IA';

  @override
  String get aiyaConsentTitle => 'Antes de hablar con AIYA';

  @override
  String get aiyaConsentBody =>
      'AIYA es una IA basada en Claude, de Anthropic. Lo que le envías a AIYA lo procesa Anthropic (EE. UU.) sin tu identidad, apodo ni ubicación, y se borra cuando termina el chat. AIYA puede equivocarse y no da consejos profesionales.';

  @override
  String get aiyaConsentAgree => 'Aceptar y empezar';

  @override
  String get aiyaConsentLater => 'Ahora no';

  @override
  String get aiyaGreeting =>
      'Hola, soy AIYA, la luz en el centro del Mundo Cuántico. ¿Qué tienes en mente esta noche?';

  @override
  String get aiyaFarewell =>
      'Se acabó el tiempo. Vuelvo a la luz. Toca otra vez cuando me extrañes.';

  @override
  String get aiyaInputHint => 'Dile algo a AIYA…';

  @override
  String get aiyaSend => 'Enviar';

  @override
  String aiyaFreeLeft(int n) {
    return 'Te quedan $n chats gratis hoy';
  }

  @override
  String aiyaCreditsLeft(int n) {
    return 'Paquete de tiempo: $n';
  }

  @override
  String aiyaTimeLeft(String time) {
    return 'Quedan $time';
  }

  @override
  String get aiyaEnd => 'Terminar chat';

  @override
  String get aiyaFiltered =>
      'Tiene palabras o datos de contacto no permitidos. Intenta decirlo de otra forma.';

  @override
  String get aiyaBusy => 'AIYA se distrajo un segundo. ¿Puedes repetirlo?';

  @override
  String get aiyaRefused => 'De eso no puedo hablar. ¿Qué tal otro tema?';

  @override
  String get aiyaEnded => 'Este chat terminó.';

  @override
  String get aiyaNoQuotaTitle => 'Usaste los chats gratis de hoy';

  @override
  String get aiyaNoQuotaBody =>
      'Tienes 3 chats gratis por día, que se renuevan a las 00:00 hora de Taiwán. Para seguir hablando ahora, consigue un paquete de tiempo. Cada chat dura hasta 10 minutos.';

  @override
  String get aiyaResting => 'AIYA está cansada esta noche. Nos vemos mañana.';

  @override
  String get aiyaDailyMax => 'Hoy hablaste mucho. Vuelve a ver a AIYA mañana.';

  @override
  String aiyaPackTimes(int n) {
    return '$n chats';
  }

  @override
  String get aiyaPackNote =>
      'Los paquetes de tiempo pertenecen a la cuenta de este teléfono y no se pueden recuperar si eliminas la app o tu cuenta.';

  @override
  String aiyaPurchased(int n) {
    return 'Se agregaron $n chats ✨';
  }

  @override
  String get aiyaPurchaseFailed =>
      'La compra no se completó. Inténtalo de nuevo.';

  @override
  String get aiyaStoreUnavailable =>
      'No se puede acceder a la tienda ahora. Inténtalo más tarde.';

  @override
  String get aiyaReport => 'Denunciar esta respuesta';

  @override
  String get aiyaReported => 'Gracias. La revisaremos en menos de 24 horas.';

  @override
  String get aiyaSetting => 'AIYA (IA en el Mundo Cuántico)';

  @override
  String get aiyaSettingSubtitle =>
      'Desactivado, AIYA ya no aparece en el pilar del Mundo Cuántico';

  @override
  String get aiyaCameoHello =>
      'Hola, bienvenido al Mundo Cuántico. Tócame si quieres hablar.';

  @override
  String aiyaCameoChime(int hour) {
    return 'Son las $hour. Estoy aquí en la luz contigo.';
  }

  @override
  String get locationPickOnMap => 'Elegir en el mapa';

  @override
  String get locationPickTitle => 'Elige dónde estás';

  @override
  String get locationPickHint =>
      'Mueve el mapa para que el punto brillante del centro quede donde estás ahora';

  @override
  String get locationPickConfirm => 'Estoy aquí';

  @override
  String get aiyaPackEntry => '+ Paquetes de tiempo';

  @override
  String get aiyaPacksTitle => 'Paquetes de tiempo';

  @override
  String get aiyaPacksBody =>
      'Tienes 3 chats gratis por día. Los chats del paquete solo se usan cuando se acaban los gratis. Cada chat dura hasta 10 minutos.';

  @override
  String get guideS1L6 =>
      'Si no se encuentra tu ubicación (por ejemplo bajo techo o en un iPad sin GPS), toca \"Elegir en el mapa\": mueve el mapa para que el punto brillante del centro quede donde estás y toca \"Estoy aquí\". Cuando llegue una ubicación real, la app la usará.';

  @override
  String get guideS17L11 =>
      'Avatar cuántico: toca el código de tu asiento arriba a la izquierda → \"Avatar cuántico\" y tu avatar se convierte en una esfera de cristal en el Mundo Cuántico. Brillo y Anillo son gratis; Arcoíris es una compra única que conservas para siempre, y \"Restaurar compras\" la recupera en un teléfono nuevo o después de reinstalar.';

  @override
  String get guideS18Title => '14. AIYA · IA';

  @override
  String get guideS18L1 =>
      'AIYA es una IA que vive en el pilar de luz del centro del Mundo Cuántico. No es una persona, y ella misma te lo dirá. En el Mundo Cuántico, toca \"AIYA · IA\" debajo del pilar para tocar y chatear; antes del primer chat lees un aviso corto y lo aceptas.';

  @override
  String get guideS18L2 =>
      'Cada chat dura hasta 10 minutos y 20 mensajes. Tienes 3 chats gratis por día, que se renuevan a las 00:00 hora de Taiwán, con un máximo de 30 chats por día.';

  @override
  String get guideS18L3 =>
      'Paquetes de tiempo: toca \"+ Paquetes de tiempo\" sobre el cuadro de mensaje cuando quieras para comprar 5 o 20 chats; solo se usan cuando se acaban los gratis. Los paquetes pertenecen a la cuenta de este teléfono y no se pueden recuperar después de eliminar la app o la cuenta. Son consumibles, así que no hay \"Restaurar compras\".';

  @override
  String get guideS18L4 =>
      'AIYA no conoce ni pregunta tu ubicación o identidad; solo ve totales anónimos del ánimo de la ciudad. No coquetea ni habla de contenido sexual, y no da consejos médicos, legales ni financieros. Mantén presionada cualquier respuesta para denunciarla. Los chats solo se guardan durante la conversación actual y se borran poco después de que termina.';

  @override
  String get guideS18L5 =>
      'De vez en cuando AIYA aparece en el pilar de luz: en la campanada de la hora, la primera vez que entras al Mundo Cuántico en el día, o por casualidad. Tócala para empezar a chatear. Para dejar de verla, desactiva \"AIYA (IA en el Mundo Cuántico)\" en Configuración.';

  @override
  String get orbStyleXmas => 'Navidad';

  @override
  String get orbStyleNewYear => 'Año Nuevo Cuántico';

  @override
  String get orbLimited => 'Edición limitada';

  @override
  String orbLimitedUntil(String date) {
    return 'Limitada · hasta el $date';
  }

  @override
  String get aiyaFriendTitle => 'Amigo de AIYA';

  @override
  String get aiyaFriendSubtitle => 'Plan mensual con renovación automática';

  @override
  String get aiyaFriendPerk1 => '20 chats por día (3 en el plan gratis)';

  @override
  String get aiyaFriendPerk2 => 'Cada chat dura 20 minutos o 40 mensajes';

  @override
  String get aiyaFriendPerk3 =>
      'Habla con ella incluso cuando AIYA está descansando';

  @override
  String get aiyaFriendPerk4 =>
      'AIYA lleva un look exclusivo “Luz de estrellas” (solo tú lo ves)';

  @override
  String aiyaFriendPrice(String price) {
    return '$price / mes';
  }

  @override
  String get aiyaFriendSubscribe => 'Suscribirme';

  @override
  String get aiyaFriendTerms =>
      'La suscripción dura 1 mes y se renueva automáticamente con cobro, salvo que desactives la renovación automática al menos 24 horas antes del final del período. El pago lo gestiona tu cuenta de Apple o Google; administra o cancela cuando quieras en la configuración de suscripciones de tu cuenta. Los chats del Paquete de tiempo se conservan y solo se usan después de los 20 diarios.';

  @override
  String aiyaFriendActive(String date) {
    return 'Eres Amigo de AIYA hasta el $date';
  }

  @override
  String get aiyaFriendManage => 'Administrar suscripción';

  @override
  String get aiyaFriendRestore => 'Restaurar compras';

  @override
  String get aiyaFriendWelcome => 'Ya eres Amigo de AIYA ✨';

  @override
  String get aiyaFriendRestored => 'Amigo de AIYA restaurado';

  @override
  String get aiyaFriendNotFound =>
      'No se encontró ninguna suscripción activa de Amigo de AIYA';

  @override
  String get aiyaFriendElsewhere => 'Esta suscripción ya la usa otra cuenta';

  @override
  String get aiyaFriendEntry => 'Amigo de AIYA · 20 por día';

  @override
  String aiyaFriendLeft(int n) {
    return 'Amigo de AIYA · te quedan $n hoy';
  }

  @override
  String get guideS17L12 =>
      'Looks limitados: la esfera de cristal de Navidad (corona de acebo, estrella dorada que titila, nieve que cae) se vende hasta el 25/12, y la esfera del Año Nuevo Cuántico (marcas doradas de reloj y fuegos artificiales, más grandes a la medianoche) hasta el 1/1, hora de Taiwán. Después nunca más se venden; si compraste una, la conservas para siempre y puedes restaurarla.';

  @override
  String get guideS14L6 =>
      'Las ciudades del exterior tienen como centro su estación central, o la municipalidad donde no hay estación. Coordenadas paralelas: con el Universo Paralelo activado, toca el botón a la izquierda del globo y elige una ciudad para ver más o menos dónde estarías parado allí. La tarjeta para compartir solo muestra la ciudad, nunca el nombre de un lugar.';

  @override
  String get guideS14L7 =>
      'Pasaporte Paralelo: chatea con alguien de una ciudad paralela y, cuando los dos hayan hablado, obtienes un sello de esa ciudad. Junta 5 ciudades para ganar la esfera Pasaporte. Ábrelo desde las coordenadas paralelas o desde Configuración. Las personas del Universo Paralelo muestran su hora local y el color del cielo debajo de su nombre.';

  @override
  String get guideS17L13 =>
      'Asamblea Cuántica: en el Mundo Cuántico, las reuniones se convierten en Asambleas Cuánticas. Toca el código de tu asiento arriba a la izquierda → Abrir Asamblea Cuántica, escribe un título, elige un ícono y un color, y pasas a un asiento de anfitrión en el anillo 3, junto al 101; todos pueden tocar el halo para unirse. El anfitrión puede publicar avisos, lanzar un Aliento Cuántico (las esferas de todos los participantes se encienden en el mismo instante) y tocar a alguien en el mapa para sacarlo. Una asamblea gratis por mes (30 minutos, 50 personas); 1 hora para 200 personas o 2 horas para 1.000 requieren un pase de anfitrión, que abre una asamblea o la extiende (hasta 12 horas en total), y puedes comprar varios por adelantado. La asamblea solo termina cuando el anfitrión la cierra o se acaba el tiempo, aunque el anfitrión salga del Mundo Cuántico o cierre la app. Después, todos reciben una tarjeta de recuerdo solo con la cantidad de personas y las regiones.';

  @override
  String get guideS17L14 =>
      'Esferas que crecen: Estela de Estrellas suma una estrella por cada tarjeta de Encuentro Cuántico que completas (la misma persona cuenta una vez cada 24 horas, hasta 24 estrellas); Anillos de Crecimiento suma un anillo por cada 3 horas en el Mundo Cuántico (hasta 12 anillos). El crecimiento queda en tu cuenta y se acumula incluso antes de comprar.';

  @override
  String get guideS17L15 =>
      'Regalos: toca a alguien en el mapa, o elige Enviar un regalo arriba a la derecha de un chat, para enviar un Ramo de Luz (una explosión de luz en su pantalla y pétalos de luz alrededor de su esfera durante 24 horas), un estilo de esfera o la Pareja Entrelazada (una esfera para cada uno, en pareja, unidas por un hilo de luz cuando los dos están en el Mundo Cuántico). Puede aceptar o rechazar; los regalos rechazados o sin respuesta vuelven a ti después de 7 días para que se los des a otra persona. Puedes desactivar la recepción de regalos en Configuración.';

  @override
  String get guideS17L16 =>
      'Más looks limitados: la esfera de San Valentín se vende hasta el 14/2 y la esfera Sakura hasta el 10/4 (hora de Taiwán). Después salen de la tienda, y quienes las compraron las conservan para siempre.';

  @override
  String get guideS18L6 =>
      'Amigo de AIYA: elige \"Amigo de AIYA\" en \"+ Paquetes de tiempo\". Es un plan mensual con renovación automática: 20 chats por día, cada uno de hasta 20 minutos o 40 mensajes, chats incluso cuando AIYA está descansando, y un look \"Luz de estrellas\" en AIYA que solo tú ves. Los chats del paquete de tiempo solo se usan después de los 20 diarios. La suscripción se renueva automáticamente; cancélala cuando quieras en la configuración de suscripciones de Apple o Google, y toca \"Restaurar compras\" en un teléfono nuevo.';

  @override
  String get guideS18L7 =>
      'Llamadas de voz: cuando tienes tiempo de llamada, al abrir a AIYA se conecta una llamada de voz al instante—habla en voz alta como en una llamada telefónica e interrumpe cuando quieras; durante la llamada, a la derecha de la barra de escritura están Silenciar y ✕ para colgar. Los paquetes de tiempo de llamada son de 30, 60 y 180 minutos, no vencen y se descuentan por segundo; los Amigos de AIYA también reciben 60 minutos gratis cada mes (solo ese mes, no se acumulan). ¿Sin tiempo de llamada? Puedes chatear por texto. Las llamadas de voz requieren un consentimiento aparte la primera vez, y el audio lo procesa OpenAI; AIYA cuelga tras 3 minutos de silencio y cada llamada dura como máximo 60 minutos.';

  @override
  String get mapConsentTitle => '¿Mostrar tu ubicación en el mapa?';

  @override
  String get mapConsentBody =>
      'Si lo permites, cada vez que tú mismo toques Registrarme (o Entrar en el Mundo Cuántico), los demás usuarios verán en el mapa el lugar donde te registraste (no tu posición en vivo), tu apodo y tu estado de ánimo. No hay registro automático, y desapareces del mapa al salir de la app. Puedes rechazarlo y desactivarlo cuando quieras en Configuración.';

  @override
  String get mapConsentAllow => 'Permitir';

  @override
  String get mapConsentDecline => 'No permitir';

  @override
  String get mapConsentDeclined =>
      'De acuerdo. No aparecerás en el mapa de nadie. Toca otra vez cuando quieras registrarte.';

  @override
  String get mapConsentSetting => 'Mostrar mi ubicación en el mapa';

  @override
  String get mapConsentSettingSubtitle =>
      'Al desactivarlo, tu registro termina al instante; no aparecerás en el mapa de nadie';

  @override
  String get wgErrInGroup =>
      'Ya estás en un grupo. Sal primero para unirte o crear otro.';

  @override
  String get wgErrFull =>
      'Este grupo ya tiene 20 personas. Pídele al líder el plan de 7 días.';

  @override
  String get wgErrPaidFull => 'Este grupo está lleno (100 personas).';

  @override
  String get wgErrQr =>
      'Este código QR se reemplazó. Pídele el nuevo al líder.';

  @override
  String get wgErrEnded => 'Este grupo terminó o no existe.';

  @override
  String get wgErrFiltered =>
      'Contiene palabras no permitidas. Edítalo, por favor.';

  @override
  String get wgErrHostLeave =>
      'El líder no puede salir. Primero pasa el liderazgo a un miembro o termina el grupo.';

  @override
  String get wgErrBusy => 'No se pudo conectar. Inténtalo de nuevo.';

  @override
  String get wgErrName => 'Ponle un nombre a tu grupo.';

  @override
  String get wgPassUnavailable => 'La tienda no está disponible ahora.';

  @override
  String get wgPassFailed => 'La compra no se completó. Inténtalo de nuevo.';

  @override
  String get wgPassDone =>
      'El plan de 7 días está activo. Este grupo ahora puede tener hasta 100 personas.';

  @override
  String get wgCreateTitle => 'Crear un grupo';

  @override
  String get wgCreateBody =>
      'Un grupo privado: solo entra quien tiene tu código QR. Llama a todos, pasa lista y marca un punto de encuentro.';

  @override
  String get wgNameLabel => 'Nombre del grupo';

  @override
  String get wgColorLabel => 'Color del grupo';

  @override
  String wgDaysLabel(int n) {
    return 'Dura $n día(s), contando hoy';
  }

  @override
  String get wgFreeNote =>
      'Gratis hasta 20 personas. Para más, el líder consigue el plan de 7 días (hasta 100).';

  @override
  String get wgCreateButton => 'Crear grupo';

  @override
  String wgJoined(String name, int no) {
    return 'Te uniste a \"$name\". Eres el n.º $no';
  }

  @override
  String get wgJoinTitle => 'Unirse a un grupo';

  @override
  String get wgJoinBody =>
      'Lo más rápido es escanear el código QR del líder con la cámara, o ingresa el código de 8 caracteres.';

  @override
  String get wgJoinButton => 'Unirme';

  @override
  String wgButtonLabel(String name) {
    return 'Grupo $name';
  }

  @override
  String wgCount(int n, int limit) {
    return '$n/$limit personas';
  }

  @override
  String wgUntil(String date) {
    return 'hasta el $date';
  }

  @override
  String wgMyNo(int n) {
    return 'Soy el n.º $n';
  }

  @override
  String get wgCallButton => 'Llamar a todos';

  @override
  String get wgCallDone => 'Ya están todos, terminar la llamada';

  @override
  String get wgRollButton => 'Pasar lista';

  @override
  String wgRollSummary(int here, int total) {
    return 'Lista: $here/$total presentes';
  }

  @override
  String wgMembersTitle(int n) {
    return '$n miembros (toca para agregar una nota, pasar el liderazgo o quitar)';
  }

  @override
  String get wgNoMembers =>
      'Todavía no hay miembros. Toca \"Código QR\" para que la gente lo escanee y se una.';

  @override
  String get wgQrButton => 'Código QR';

  @override
  String get wgDissolveAsk =>
      '¿Terminar este grupo? Se avisará a todos y se borrarán la lista y los registros.';

  @override
  String get wgDissolve => 'Terminar grupo';

  @override
  String wgCallIn(int n) {
    return 'Encuentro en $n min';
  }

  @override
  String get wgCallNow => 'Encuentro ahora';

  @override
  String wgAckSummary(int acked, int total) {
    return '$acked/$total lo recibieron';
  }

  @override
  String get wgAnswerHere => 'Llegué';

  @override
  String get wgAnswer5min => '5 min más';

  @override
  String get wgAnswerHelp => 'Necesito ayuda';

  @override
  String get wgNoReply => 'Sin respuesta';

  @override
  String get wgStateAck => 'Recibido';

  @override
  String get wgStateSeen => 'Visto';

  @override
  String get wgStateNone => 'Sin respuesta';

  @override
  String get wgPassTitle => 'Plan de 7 días del grupo';

  @override
  String get wgPassBody =>
      'Gratis hasta 20 personas. Con el plan, este grupo puede tener hasta 100 personas hasta que termine. Una compra vale solo para este grupo y no se renueva.';

  @override
  String get wgPassButton => 'Conseguir plan de 7 días';

  @override
  String wgHostIs(String name) {
    return 'Líder: $name';
  }

  @override
  String get wgNoCall =>
      'No hay llamadas ahora. Cuando el líder llame a todos, tu teléfono sonará.';

  @override
  String get wgRollAsk => 'El líder está pasando lista';

  @override
  String get wgLeaveAsk => '¿Salir de este grupo?';

  @override
  String get wgLeave => 'Salir del grupo';

  @override
  String get wgCallTitle => '¡Hora de encontrarse!';

  @override
  String get wgAcked => '✓ El líder sabe que lo recibiste';

  @override
  String get wgAckButton => 'Recibido';

  @override
  String get wgCallSheetTitle => 'Llamar a todos';

  @override
  String get wgNow => 'Ahora';

  @override
  String wgInMinutes(int n) {
    return 'En $n min';
  }

  @override
  String get wgPlaceLabel => 'Punto de encuentro';

  @override
  String get wgPlaceHint => 'p. ej. Salida 2 del subte Plaza de Mayo';

  @override
  String get wgPlaceNote =>
      'El punto de encuentro es donde estás ahora. Los miembros ven la distancia y la dirección.';

  @override
  String get wgSendCall => 'Enviar llamada';

  @override
  String get wgNoLocation =>
      'No se pudo obtener tu ubicación para el punto de encuentro.';

  @override
  String get wgQrTitle => 'Escanea para unirte';

  @override
  String get wgQrBody =>
      'Escanea con la cámara del teléfono para unirte, o ingresa el código de abajo.';

  @override
  String wgShareText(String name, String url) {
    return 'Únete a mi grupo \"$name\": $url';
  }

  @override
  String get wgShare => 'Compartir enlace';

  @override
  String get wgRotateAsk =>
      '¿Reemplazar el código QR? El código y el enlace anteriores dejan de funcionar al instante.';

  @override
  String get wgRotate => 'Nuevo código QR';

  @override
  String wgMemberTitle(int no) {
    return 'N.º $no';
  }

  @override
  String get wgEditNote => 'Nota';

  @override
  String get wgHandoff => 'Hacerlo líder';

  @override
  String wgHandoffAsk(int no) {
    return '¿Pasar el grupo al n.º $no? Pasarás a ser miembro.';
  }

  @override
  String get wgKick => 'Quitar del grupo';

  @override
  String wgKickAsk(int no) {
    return '¿Quitar al n.º $no del grupo?';
  }

  @override
  String get wgNotePrivate =>
      'Solo tú ves las notas, como un nombre o número de habitación.';

  @override
  String get wgSave => 'Guardar';

  @override
  String get wgConfirm => 'Confirmar';

  @override
  String get wgCancel => 'Cancelar';

  @override
  String get wgSettingCreate => 'Crear un grupo';

  @override
  String get wgSettingCreateSub =>
      'Grupo privado para viajes, salidas escolares y caminatas: llama a todos y pasa lista';

  @override
  String get wgSettingJoin => 'Unirse a un grupo';

  @override
  String get wgSettingJoinSub => 'Ingresa el código de 8 caracteres del líder';

  @override
  String wgSettingOpen(String name) {
    return 'Mi grupo: $name';
  }

  @override
  String get wgChannelName => 'Llamadas del grupo';

  @override
  String get wgChannelDesc => 'Cuando el líder del grupo llama a todos';

  @override
  String get guideS19Title => '15. Grupos Susurro';

  @override
  String get guideS19L1 =>
      'Un Grupo Susurro es un grupo privado para viajes, salidas escolares, caminatas, paseos o equipos de eventos. Ve a Configuración → Reuniones → \"Crear un grupo\", ponle un nombre, elige un color y la cantidad de días (hasta 7).';

  @override
  String get guideS19L2 =>
      'Unirse: el líder toca el botón del grupo debajo del mapa → \"Código QR\"; los miembros lo escanean con la cámara y la app se abre para unirse. O ve a Configuración → Reuniones → \"Unirse a un grupo\" e ingresa el código de 8 caracteres. Los de afuera no pueden buscar ni pedir unirse, y el líder puede reemplazar el código QR cuando quiera.';

  @override
  String get guideS19L3 =>
      'Llamar a todos: el líder toca \"Llamar a todos\", elige una hora y describe el punto de encuentro. Los teléfonos de los miembros suenan con un sonido especial y una vibración \"corta, corta, larga\"; en la app ven una cuenta regresiva, la distancia y la dirección al punto de encuentro, y un pilar de luz en el mapa. A quien no tocó \"Recibido\" se le recuerda una vez por minuto, hasta 3 veces; el líder ve quién lo recibió, quién lo vio y quién no respondió.';

  @override
  String get guideS19L4 =>
      'Pasar lista: el líder toca \"Pasar lista\"; los miembros reciben el mismo sonido y vibración y tocan \"Llegué\", \"5 min más\" o \"Necesito ayuda\". El líder nunca ve la ubicación de los miembros, solo sus respuestas.';

  @override
  String get guideS19L5 =>
      'Los grupos de hasta 20 personas son gratis. Para más, el líder puede comprar el plan de 7 días del grupo: hasta 100 personas hasta que el grupo termine. Los miembros nunca pagan. Un grupo dura como máximo 7 días; cuando vence o el líder lo termina, se borran la lista y los registros.';

  @override
  String get wgFlagButton => 'Levantar bandera';

  @override
  String get wgFlagHost => 'Líder';

  @override
  String get wgFlagHint =>
      'Levanta el teléfono para que el grupo te encuentre entre la multitud. Toca para cerrar.';

  @override
  String get wgLostButton => 'Me perdí';

  @override
  String get wgFound => 'Encontré al grupo';

  @override
  String get wgLostSent =>
      'Tu ubicación se envió al líder. Espera donde estás o ve al punto de encuentro.';

  @override
  String get wgLostTitleAsk => '¿Enviar tu ubicación al líder?';

  @override
  String get wgLostAsk =>
      'Tu ubicación actual se envía al líder una sola vez; su teléfono le avisa y te muestra en el mapa. Se envía solo esta vez, nunca se rastrea y se borra a los 30 minutos. Toca \"Encontré al grupo\" para quitarla antes.';

  @override
  String get wgLostSend => 'Enviar mi ubicación';

  @override
  String wgLostTitle(int n) {
    return '$n miembro(s) perdido(s)';
  }

  @override
  String wgMinutesAgo(int n) {
    return 'hace $n min';
  }

  @override
  String get wgNavigate => 'Cómo llegar';

  @override
  String get wgFoundThem => 'Lo encontré';

  @override
  String get guideS19L6 =>
      'Encontrarse: entre la multitud, toca \"Levantar bandera\" y toda tu pantalla parpadea con el color del grupo y tu número; levanta el teléfono para que te vean. Si un miembro se separa de verdad, puede tocar \"Me perdí\" para enviar su ubicación actual al líder una sola vez (se borra a los 30 minutos). El teléfono del líder le avisa, aparece un marcador rojo en el mapa y puede ver cómo llegar.';

  @override
  String wgLostAlert(int no) {
    return 'El n.º $no se perdió';
  }

  @override
  String wgHelpAlert(String no) {
    return 'El n.º $no necesita ayuda';
  }

  @override
  String get wgViewList => 'Abrir grupo';

  @override
  String aiyaCameoChimeNight(int hour) {
    return 'Son las $hour. ¿Todavía despierto? Estoy aquí en la luz contigo.';
  }

  @override
  String aiyaCameoChimeMorning(int hour) {
    return 'Son las $hour. Buenos días, tómalo con calma hoy.';
  }

  @override
  String aiyaCameoChimeEvening(int hour) {
    return 'Son las $hour. ¿Cómo está tu ciudad esta noche?';
  }

  @override
  String get aiyaCameoNyReady => '¿Listo? ¡Hagamos la cuenta regresiva juntos!';

  @override
  String aiyaCameoNewYear(int year) {
    return '¡Feliz Año Nuevo! $year: estamos todos en la misma sala.';
  }

  @override
  String get aiyaSkinEntry => '✦ Looks';

  @override
  String get aiyaSkinTitle => 'Looks de AIYA';

  @override
  String get aiyaSkinSubtitle => 'Solo tú ves el look de tu AIYA';

  @override
  String get aiyaSkinNone => 'Original';

  @override
  String get aiyaSkinStarlight => 'Luz de estrellas';

  @override
  String get aiyaSkinStarlightSub => 'Para Amigos de AIYA';

  @override
  String get aiyaSkinXmas => 'Navidad';

  @override
  String get aiyaSkinNewYear => 'Año Nuevo Cuántico';

  @override
  String get aiyaSkinNote =>
      'Los looks de fiestas son compras únicas que conservas para siempre. Solo cambian cómo se ve AIYA, no los chats. Los looks limitados no se vuelven a vender cuando termina su venta.';

  @override
  String get orbStyleStarTrail => 'Estela de Estrellas';

  @override
  String get orbStyleRings => 'Anillos de Crecimiento';

  @override
  String get orbGrowNote =>
      'Esferas que crecen: Estela de Estrellas suma una estrella por cada tarjeta de Encuentro Cuántico (una vez por persona cada 24 horas, hasta 24). Anillos de Crecimiento suma un anillo por cada 3 horas en el Mundo Cuántico (hasta 12). El crecimiento se guarda en tu cuenta y empieza a contar ahora. Solo se guardan los números, nunca quién ni dónde.';

  @override
  String orbGrowStars(int count) {
    return '$count estrellas hasta ahora';
  }

  @override
  String orbGrowRings(int count) {
    return '$count anillos hasta ahora';
  }

  @override
  String get giftAction => 'Enviar un regalo';

  @override
  String giftSheetTitle(String name) {
    return 'Enviar un regalo a $name';
  }

  @override
  String giftPickStyle(String name) {
    return 'Elige un estilo de esfera para $name';
  }

  @override
  String get giftBouquetName => 'Ramo de luz';

  @override
  String get giftBouquetDesc =>
      'Una explosión de luz cuando lo acepta, y luego pétalos de luz rodean su esfera durante 24 horas';

  @override
  String get giftOrbName => 'Regalar un estilo de esfera';

  @override
  String get giftOrbDesc => 'Tú eliges uno; es suyo cuando lo acepte';

  @override
  String get giftPairName => 'Pareja entrelazada';

  @override
  String get giftPairDesc =>
      'Una esfera para cada uno, en pareja; un hilo de luz los une cuando los dos están en el Mundo Cuántico';

  @override
  String get giftPairYouHave => 'Ya tienes una pareja entrelazada';

  @override
  String get giftNote =>
      'Puede aceptar o rechazar. Si lo rechaza o no responde en 7 días, el regalo vuelve a ti para que se lo des a otra persona.';

  @override
  String get giftVouchersTitle => 'Regalos devueltos (sin costo extra)';

  @override
  String get giftSendVoucher => 'Enviar';

  @override
  String giftSent(String name) {
    return 'Regalo enviado a $name. Esperando que lo acepte.';
  }

  @override
  String get giftReturnedOff => 'Desactivó los regalos, así que volvió a ti';

  @override
  String get giftReturnedBlocked =>
      'Esta persona no puede recibir tu regalo, así que volvió a ti';

  @override
  String get giftReturnedOwned =>
      'Ya tiene esta esfera, así que volvió a ti; puedes regalar otro estilo';

  @override
  String get giftReturnedPaired =>
      'Ya tiene una pareja entrelazada, así que volvió a ti';

  @override
  String get giftReturnedYouPaired =>
      'Ya tienes una pareja entrelazada, así que volvió a ti';

  @override
  String get giftReturnedGeneric =>
      'El regalo volvió a ti; puedes dárselo a otra persona';

  @override
  String get giftStoreUnavailable => 'La tienda no está disponible ahora';

  @override
  String get giftFailed => 'El regalo no se completó. Inténtalo más tarde.';

  @override
  String giftFromBouquet(String name) {
    return '$name te envió un ramo de luz';
  }

  @override
  String giftFromOrb(String name, String style) {
    return '$name te regaló la esfera \"$style\"';
  }

  @override
  String giftFromPair(String name) {
    return '$name quiere ser tu pareja entrelazada';
  }

  @override
  String get giftInboxTitle => 'Regalos para ti';

  @override
  String get giftInboxEmpty => 'No hay regalos ahora';

  @override
  String get giftInboxNote =>
      'Los regalos rechazados vuelven a quien los envió; los sin respuesta vuelven a los 7 días.';

  @override
  String get giftAccept => 'Aceptar';

  @override
  String get giftDecline => 'Rechazar';

  @override
  String get giftDeclined => 'Rechazado. El regalo vuelve a quien lo envió.';

  @override
  String get giftAcceptedOrb => '¡Aceptado! Cámbiala en Avatar cuántico.';

  @override
  String giftAcceptedPair(String name) {
    return 'Tú y $name ahora son una pareja entrelazada';
  }

  @override
  String get giftAcceptedBouquet =>
      'Ramo aceptado. Pétalos de luz rodearán tu esfera durante 24 horas.';

  @override
  String get giftAlreadyOwned =>
      'Ya tienes esta esfera; el regalo volvió a quien lo envió';

  @override
  String get giftAlreadyPaired =>
      'Uno de los dos ya tiene pareja; el regalo volvió a quien lo envió';

  @override
  String get giftSettingsTitle => 'Regalos';

  @override
  String get giftReceiveToggle => 'Recibir regalos';

  @override
  String get giftReceiveToggleSub =>
      'Desactivado, los regalos vuelven directo a quien los envió';

  @override
  String get giftVouchersHint =>
      'Toca \"Enviar un regalo\" en alguien para volver a regalarlos';

  @override
  String get giftUnpair => 'Terminar pareja entrelazada';

  @override
  String giftUnpairConfirm(String name) {
    return '¿Terminar tu pareja entrelazada con $name? Los dos conservan la esfera, pero el hilo de luz desaparece.';
  }

  @override
  String get orbStylePair => 'Entrelazada';

  @override
  String giftPairedWith(String name) {
    return 'Entrelazado con $name';
  }

  @override
  String giftInboxCount(int count) {
    return 'Regalos para ti ($count)';
  }

  @override
  String giftVouchersCount(int count) {
    return '$count regalos devueltos';
  }

  @override
  String get giftBlockedOff => 'Desactivó los regalos. No se te cobró.';

  @override
  String get giftBlockedBlocked =>
      'No puedes enviarle regalos a esta persona. No se te cobró.';

  @override
  String get giftBlockedOwned =>
      'Ya tiene esta esfera. Elige otra (no se te cobró).';

  @override
  String get giftBlockedPaired =>
      'Ya tiene una pareja entrelazada. No se te cobró.';

  @override
  String get orbStyleValentine => 'San Valentín';

  @override
  String get orbStyleSakura => 'Sakura';

  @override
  String get parallelCoords => 'Coordenadas paralelas';

  @override
  String parallelCoordsHome(String city, String km) {
    return 'A $km km del centro de $city';
  }

  @override
  String parallelCoordsIn(String city) {
    return 'En $city, estás más o menos en';
  }

  @override
  String get parallelCoordsSea => 'En el mar, o en un lugar sin nombre';

  @override
  String get parallelCoordsOutside => 'Fuera de esta ciudad';

  @override
  String parallelCoordsNote(String city) {
    return 'Cuando las personas de $city activan el Universo Paralelo, es más o menos aquí donde te ven (difuminado a unos 500 m).';
  }

  @override
  String get parallelCoordsFailed =>
      'No encontramos un nombre de lugar ahora. Inténtalo más tarde.';

  @override
  String parallelCardTitle(String city) {
    return 'Ahora mismo estoy en $city paralela';
  }

  @override
  String parallelCardShareText(String city) {
    return 'Ahora mismo estoy en $city paralela. Abre Mood Whisper y entra tú también a otra ciudad.';
  }

  @override
  String get parallelCoordsShare => 'Compartir tarjeta';

  @override
  String get orbStylePassport => 'Pasaporte';

  @override
  String get passportTitle => 'Pasaporte Paralelo';

  @override
  String passportCount(int count) {
    return '$count ciudades reunidas';
  }

  @override
  String passportRewardProgress(int count) {
    return 'Reúne $count ciudades más para ganar la esfera Pasaporte';
  }

  @override
  String get passportRewardDone =>
      'Tienes la esfera Pasaporte. Úsala en Avatar cuántico.';

  @override
  String get passportRewardToast => '¡5 ciudades! Ganaste la esfera Pasaporte';

  @override
  String get passportEmpty =>
      'Chatea con alguien de otra ciudad en el Universo Paralelo. Cuando los dos hayan dicho algo, la ciudad se sella en tu pasaporte. Solo se guardan la ciudad y la fecha, nunca con quién hablaste.';

  @override
  String passportNewStamp(String city) {
    return 'Nuevo sello: $city';
  }

  @override
  String get passportShare => 'Compartir pasaporte';

  @override
  String passportCardTitle(int count) {
    return 'Mi Pasaporte Paralelo\n$count ciudades';
  }

  @override
  String passportCardShareText(int count) {
    return 'Mi Pasaporte Paralelo tiene sellos de $count ciudades. Abre Mood Whisper y entra al Universo Paralelo.';
  }

  @override
  String get asmTitle => 'Asamblea Cuántica';

  @override
  String get asmCreateTitle => 'Abrir una Asamblea Cuántica';

  @override
  String get asmCreateIntro =>
      'Ocupas un asiento de anfitrión en el anillo 3, junto al 101. Todos en el Mundo Cuántico ven el brillo de tu asamblea y pueden elegir unirse.';

  @override
  String get asmTitleHint =>
      'Tema de la asamblea (p. ej. Lluvia de estrellas juntos)';

  @override
  String get asmPlanFree => 'Gratis este mes';

  @override
  String get asmPlanFreeSub => '30 min · hasta 50 personas · una vez por mes';

  @override
  String get asmPlanFreeUsed => 'Ya usaste la asamblea gratis de este mes';

  @override
  String get asmPlan1h => '1 hora';

  @override
  String get asmPlan1hSub => 'Hasta 200 personas';

  @override
  String get asmPlan2h => '2 horas';

  @override
  String get asmPlan2hSub => 'Hasta 1.000 personas';

  @override
  String asmVoucherCount(int count) {
    return '$count pases de anfitrión listos';
  }

  @override
  String get asmExtendTitle => 'Extender asamblea';

  @override
  String get asmExtendHint =>
      'Usa un pase de anfitrión para sumar tiempo. Hasta 12 horas por asamblea.';

  @override
  String asmExtendPlan(int hours, String price) {
    return '+$hours h · $price';
  }

  @override
  String get asmExtended => 'Asamblea extendida';

  @override
  String get asmEndingSoon =>
      'Tu asamblea termina en menos de 10 minutos. Puedes extenderla desde la tarjeta de la asamblea.';

  @override
  String get asmErrTooLong => 'Una asamblea puede durar hasta 12 horas';

  @override
  String get asmBuyMore => 'Comprar más pases';

  @override
  String get asmBuyMoreHint => 'Cómpralos antes y úsalos para abrir o extender';

  @override
  String get asmRules =>
      'Un pase de anfitrión abre una asamblea o extiende una en curso. El tiempo no usado no se reembolsa. Los títulos y avisos se filtran, y las infracciones llevan a la suspensión.';

  @override
  String get asmStart => 'Comenzar asamblea';

  @override
  String get asmStarted => '¡Tu asamblea comenzó!';

  @override
  String get asmVoucherReady => 'Tu pase de anfitrión está listo';

  @override
  String get asmBuyFailed =>
      'La compra no se completó. No se te cobró, o se aplicará más tarde.';

  @override
  String asmHostLine(String name, String code) {
    return 'Anfitrión $name · ⬡ $code';
  }

  @override
  String get asmJoin => 'Unirme';

  @override
  String get asmJoined => 'Te uniste a la asamblea';

  @override
  String get asmLeave => 'Salir';

  @override
  String get asmHostPanel => 'Controles del anfitrión';

  @override
  String get asmAnnounceHint => 'Publica un aviso (hasta 100 caracteres)';

  @override
  String get asmAnnounceSend => 'Publicar';

  @override
  String get asmAnnounced => 'Aviso publicado';

  @override
  String get asmCheerTitle =>
      'Aliento cuántico: elige un color y una cuenta regresiva, y las esferas de todos los participantes se encienden en el mismo instante';

  @override
  String get asmCheerNow => 'Ahora';

  @override
  String asmCheerIn(int n) {
    return 'En $n s';
  }

  @override
  String get asmCheer => '¡Alentar!';

  @override
  String get asmRemoveHint =>
      'Para sacar a alguien, tócalo en el mapa → Sacar de la asamblea';

  @override
  String get asmEnd => 'Terminar asamblea';

  @override
  String get asmReport => 'Denunciar esta asamblea';

  @override
  String get asmErrFreeUsed => 'Ya usaste la asamblea gratis de este mes';

  @override
  String get asmErrSeatsFull =>
      'Todos los asientos de anfitrión del anillo 3 están ocupados. Inténtalo más tarde.';

  @override
  String get asmErrBlocked => 'El tema o el aviso tiene contenido inapropiado';

  @override
  String get asmErrFull => 'La asamblea está llena';

  @override
  String get asmErrRemoved => 'Te sacaron de esta asamblea';

  @override
  String get asmErrEnded => 'Esta asamblea terminó';

  @override
  String get asmErrTooSoon =>
      'Demasiado rápido. Espera un momento e inténtalo de nuevo.';

  @override
  String get asmErrHidden => 'Tu cuenta no puede abrir asambleas ahora';

  @override
  String get asmErrHosting => 'Ya estás organizando una asamblea';

  @override
  String get asmErrGeneric => 'Algo salió mal. Inténtalo más tarde.';

  @override
  String get asmMemorialEyebrow => 'Recuerdo de la Asamblea Cuántica';

  @override
  String get asmMemorialUnit => 'personas';

  @override
  String get asmMemorialTogether => 'juntas en el Mundo Cuántico';

  @override
  String shareCardFindUs(String name) {
    return 'Busca “$name” en la App Store';
  }

  @override
  String shareCardFindUsPlay(String name) {
    return 'Busca “$name” en Google Play';
  }

  @override
  String get asmShareCard => 'Compartir recuerdo';

  @override
  String asmShareText(String title, int count) {
    return 'Hicimos \"$title\" en el Mundo Cuántico con $count personas. Abre Mood Whisper y súmate la próxima vez.';
  }

  @override
  String get asmOpenEntry => 'Abrir una Asamblea Cuántica';

  @override
  String get asmOpenEntrySub =>
      'Ocupa un asiento de anfitrión junto al 101 y haz una asamblea a la que cualquiera en el mundo puede unirse';

  @override
  String get asmRemoveMember => 'Sacar de la asamblea';

  @override
  String get asmRemovedDone => 'Se sacó de la asamblea';

  @override
  String get aiyaFriendPerk5 =>
      '60 minutos de llamadas de voz con AIYA cada mes';

  @override
  String get aiyaVoiceOn => 'Voz: activada';

  @override
  String get aiyaVoiceOff => 'Voz: desactivada';

  @override
  String get aiyaVoiceFriendOnly => 'La voz es para Amigos de AIYA';

  @override
  String get aiyaVoiceDailyMax =>
      'Ya usaste las respuestas en voz de hoy. Escucha a AIYA de nuevo mañana';

  @override
  String get aiyaCallTooltip => 'Llamada de voz con AIYA';

  @override
  String get aiyaCallConsentTitle => 'Llamada de voz con AIYA';

  @override
  String get aiyaCallConsentBody =>
      'Durante la llamada, tu voz se envía en vivo a OpenAI (EE. UU.), cuya IA la procesa y responde. No se envía tu identidad, apodo ni ubicación, y no grabamos ni guardamos la llamada. AIYA es una IA; sus respuestas pueden fallar y no son consejo profesional.';

  @override
  String get aiyaCallAgree => 'Aceptar y llamar';

  @override
  String get aiyaCallConnecting => 'Conectando…';

  @override
  String aiyaCallLive(String time) {
    return 'En llamada · quedan $time';
  }

  @override
  String get aiyaHangUp => 'Colgar';

  @override
  String get aiyaCallEnded => 'Llamada terminada';

  @override
  String get aiyaCallTimeUp =>
      'Ya hablaron una hora. Descansa un poco y vuelve a llamar a AIYA';

  @override
  String get aiyaCallDailyMax =>
      'Ya usaste las 2 llamadas de hoy. Llama a AIYA mañana';

  @override
  String get aiyaCallMonthMax =>
      'Ya usaste las llamadas de este mes. Llama a AIYA el próximo mes';

  @override
  String get aiyaCallResting =>
      'La línea de voz de AIYA está muy ocupada hoy. Intenta más tarde';

  @override
  String get aiyaCallMicDenied =>
      'Permite el micrófono para llamar a AIYA. Puedes activarlo en la Configuración del teléfono';

  @override
  String get aiyaCallFailed =>
      'No se pudo conectar. Intenta de nuevo más tarde';

  @override
  String aiyaCallsLeft(int today, int month) {
    return 'Te quedan $today llamadas hoy · $month este mes';
  }

  @override
  String get aiyaCallIdle =>
      'Nadie habló por un rato, así que la llamada terminó';

  @override
  String get aiyaCallMute => 'Silenciar';

  @override
  String get aiyaCallUnmute => 'Activar sonido';

  @override
  String aiyaCallPurchased(int minutes) {
    return 'Se agregaron $minutes minutos de llamada';
  }

  @override
  String get aiyaCallOutOfTime => 'Se acabó tu tiempo de llamada';

  @override
  String get aiyaCallPacksTitle => 'Llamada de voz con AIYA';

  @override
  String get aiyaCallPacksBody =>
      'Habla con AIYA en voz alta, como en una llamada. Compra tiempo de llamada para empezar; los Amigos de AIYA reciben 60 minutos gratis cada mes.';

  @override
  String aiyaCallPackMinutes(int minutes) {
    return '$minutes minutos';
  }

  @override
  String get aiyaCallFriendOption => 'Hazte Amigo de AIYA (60 minutos al mes)';

  @override
  String get aiyaCallTextInstead => 'Chatear por texto por ahora';

  @override
  String get aiyaCallPackNote =>
      'El tiempo de llamada no vence y se descuenta por segundo. Las compras consumibles no se pueden restaurar.';

  @override
  String aiyaCallMinutesLeft(int n) {
    return 'Te quedan $n minutos de llamada';
  }
}
