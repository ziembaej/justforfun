import { useState } from "react";
import { WhisperClient } from "react-whisper";
import openai from "openai";
import { config } from "./config";
import { Button, Panel } from "react-gears";

// Set up OpenAI credentials
openai.apiKey = config.openaiApiKey;

function App() {
  const [input, setInput] = useState("");
  const [output, setOutput] = useState("");
  const whisper = new WhisperClient(config.whisperApiKey);

  const transcribeAndPrompt = async () => {
    try {
      // Record speech input using Whisper
      const response = await whisper.speak();

      // Transcribe the speech input
      const transcript = response.transcript;

      // Prompt GPT with the transcribed text
      const prompt = `Input: ${transcript}\nOutput:`;

      // Generate text using GPT
      const { data } = await openai.completions.create({
        engine: "text-davinci-002",
        prompt: prompt,
        maxTokens: 1024,
        n: 1,
        temperature: 0.5,
      });

      // Set the generated text as the output state
      setOutput(data.choices[0].text.trim());

      // Play the generated text as speech
      await whisper.say(output);
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <div>
      <Button onClick={transcribeAndPrompt}>Speak</Button>
      <Panel>
        <p>Input: {input}</p>
        <p>Output: {output}</p>
      </Panel>
    </div>
  );
}

export default App;


