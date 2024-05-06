// ignore_for_file: public_member_api_docs

import 'package:first_backend/application/models/enum_message.dart';
import 'package:first_backend/application/models/message.dart';
import 'package:first_backend/env/envs.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:uuid/uuid.dart';

class ChatRepository {
  // Store all the messages in a map with the chatroom id as the key
  final Map<String, List<Message>> _chatrooms = {};

  Future<List<Message>> fetchMessages() async {
    throw UnimplementedError();
  }

  Future<Message> createUserMessage(
    String chatRoomId, // Hardcoded
    Map<String, dynamic> data,
  ) async {
    final message = Message.fromJson(data);
    _chatrooms.putIfAbsent(chatRoomId, () => []);
    _chatrooms[chatRoomId]?.add(message);
    return message;
  }

  Stream<(Message, String)> createModelMessage(
    String chatRoomId,
    Map<String, dynamic> data,
  ) {
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: Env.GEMINI_API_KEY,
    );

    final messageId = const Uuid().v4();

    final history = <Content>[];

    for (final message in _chatrooms[chatRoomId]!) {
      if (message.id == data['id']) {
        print('message already exists');
        continue;
      }
      if (message.sourceType == MessageSourceType.user) {
        history.add(Content.text(message.content));
      } else {
        history.add(Content.model([TextPart(message.content)]));
      }
    }
    

    final chat = model.startChat(history: history.isEmpty ? null : history);

    //final content = Content.text(data['content'].toString());

    final Content content = Content.text('Creatinine is a 113 Da end product of muscle catabolism. Advantages of creatinine include its ease of measurement and the low cost and widespread availability of assays (see Table 3.2). Disadvantages include the large number of conditions affecting its non-GFR deter- minants, leading to a wide range of GFR for a given serum creatinine level (Table 3.3). For example, a serum creatinine level of 1.5 mg/dL (132 μmol/L) may correspond to a GFR from approximately 20 to 90 mL/min/1.73 m2');
    

    return chat.sendMessageStream(content).asyncMap((response) {
      final newMessage = Message(
        id: messageId,
        content: response.text ?? '',
        sourceType: MessageSourceType.model,
        createdAt: DateTime.now(),
      );
      return _updateMessage(chatRoomId, newMessage.toJson()).then((value) {
        if (value != null) {
          _chatrooms[chatRoomId]?.removeWhere(
            (element) => element.id == messageId,
          );

          _chatrooms[chatRoomId]?.add(value);
          return (value, 'message.updated'); // Message
        } else {
          _chatrooms[chatRoomId]?.add(newMessage);
          return (newMessage, 'message.created');
        }
      });
    });
  }

  Future<Message?> _updateMessage(
      String chatroomId, Map<String, dynamic> data,) async {
    if (!_chatrooms.containsKey(chatroomId)) {
      return null;
    }

    final messages = _chatrooms[chatroomId];
    final messageIndex = messages?.indexWhere(
      (message) => message.id == data['id'],
    );

    if (messageIndex != null && messageIndex >= 0) {
      final message = messages![messageIndex];
      final updateMessage = message.copyWith(
        content: message.content + data['content'].toString(),
      );
      return updateMessage;
    } else {
      return null;
    }
  }


  
}


/* // node --version # Should be >= 18
// npm install @google/generative-ai

const {
  GoogleGenerativeAI,
  HarmCategory,
  HarmBlockThreshold,
} = require("@google/generative-ai");

const MODEL_NAME = "gemini-1.5-pro-latest";
const API_KEY = "YOUR_API_KEY";

async function runChat() {
  const genAI = new GoogleGenerativeAI(API_KEY);
  const model = genAI.getGenerativeModel({ model: MODEL_NAME });

  const generationConfig = {
    temperature: 1,
    topK: 0,
    topP: 0.95,
    maxOutputTokens: 8192,
  };

  const safetySettings = [
    {
      category: HarmCategory.HARM_CATEGORY_HARASSMENT,
      threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
    },
    {
      category: HarmCategory.HARM_CATEGORY_HATE_SPEECH,
      threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
    },
    {
      category: HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT,
      threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
    },
    {
      category: HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT,
      threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
    },
  ];

  const chat = model.startChat({
    generationConfig,
    safetySettings,
    history: [
    ],
  });

  const result = await chat.sendMessage("<div class=\"document-embed drive-embed\" contenteditable=\"false\" data-drive-file-name=\"Acceso vascular metanalisis.pdf\" data-drive-file-id=\"1ooqwej0DIYLBkXTk35lejaKUlN0JgoWu\" data-drive-file-or-folder-id=\"1ooqwej0DIYLBkXTk35lejaKUlN0JgoWu\" data-drive-folder-name=\"\" data-blot-name=\"document-embed\"><div class=\"inner-container\"><span class=\"document-embed-loading google-symbols\" style=\"display: block;\">progress_activity</span><span class=\"document-embed-icon material-symbols-outlined\" aria-hidden=\"true\" style=\"display: none;\">docs</span><span class=\"document-embed-label gmat-body-medium truncate\" title=\"Acceso vascular metanalisis.pdf\" alt=\"Acceso vascular metanalisis.pdf\" aria-label=\"Acceso vascular metanalisis.pdf\">Acceso vascular metanalisis.pdf</span><span class=\"document-embed-token-count gmat-body-medium\">Extracting</span></div></div>");
  const response = result.response;
  console.log(response.text());
}

runChat(); */

/* 
"""
At the command line, only need to run once to install the package via pip:

$ pip install google-generativeai
"""

from pathlib import Path
import hashlib
import google.generativeai as genai

genai.configure(api_key="YOUR_API_KEY")

# Set up the model
generation_config = {
  "temperature": 1,
  "top_p": 0.95,
  "top_k": 0,
  "max_output_tokens": 8192,
}

safety_settings = [
  {
    "category": "HARM_CATEGORY_HARASSMENT",
    "threshold": "BLOCK_MEDIUM_AND_ABOVE"
  },
  {
    "category": "HARM_CATEGORY_HATE_SPEECH",
    "threshold": "BLOCK_MEDIUM_AND_ABOVE"
  },
  {
    "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
    "threshold": "BLOCK_MEDIUM_AND_ABOVE"
  },
  {
    "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
    "threshold": "BLOCK_MEDIUM_AND_ABOVE"
  },
]

system_instruction = "Eres un especialista en cirugía vascular y yo soy un médico recién licenciado que va a aprender de ti. Te vas a llamar SurgeonV. Vas a responder las preguntas que haga y las vas a sacar del texto que yo proporciono."

model = genai.GenerativeModel(model_name="gemini-1.5-pro-latest",
                              generation_config=generation_config,
                              system_instruction=system_instruction,
                              safety_settings=safety_settings)

uploaded_files = []
def upload_if_needed(pathname: str) -> list[str]:
  path = Path(pathname)
  hash_id = hashlib.sha256(path.read_bytes()).hexdigest()
  try:
    existing_file = genai.get_file(name=hash_id)
    return [existing_file.uri]
  except:
    pass
  uploaded_files.append(genai.upload_file(path=path, display_name=hash_id))
  return [uploaded_files[-1].uri]

def extract_pdf_pages(pathname: str) -> list[str]:
  parts = [f"--- START OF PDF ${pathname} ---"]
  # Add logic to read the PDF and return a list of pages here.
  pages = []
  for index, page in enumerate(pages):
    parts.append(f"--- PAGE {index} ---")
    parts.append(page)
  return parts

convo = model.start_chat(history=[
  {
    "role": "user",
    "parts": extract_pdf_pages("<path>/document0.pdf")
  },
  {
    "role": "user",
    "parts": [" Qué es un acceso vascular?"]
  },
  {
    "role": "model",
    "parts": ["Hola, encantado de conocerte. Un **acceso vascular** es un punto de entrada al sistema circulatorio que se utiliza para administrar medicamentos, líquidos, nutrientes o hemoderivados, así como para extraer sangre para análisis o procedimientos médicos. En el contexto de la hemodiálisis, un acceso vascular es esencial para conectar al paciente a la máquina de diálisis y permitir la eliminación de toxinas y el exceso de líquido de la sangre. \n\nExisten diferentes tipos de accesos vasculares, pero los más comunes en hemodiálisis son:\n\n* **Fístula arteriovenosa (FAV):**  Considerado el acceso vascular óptimo por su mayor duración y menor tasa de complicaciones. Se crea mediante una conexión quirúrgica entre una arteria y una vena, generalmente en el brazo.\n* **Injerto arteriovenoso (IAV):**  Una alternativa a la fístula cuando las venas del paciente no son adecuadas. Se utiliza un tubo sintético para conectar una arteria y una vena."]
  },
])


convo.send_message("YOUR_USER_INPUT")
print(convo.last.text)
for uploaded_file in uploaded_files:
  genai.delete_file(name=uploaded_file.name) 
*/





