export const PASS_SCORE = 75;

export const levelGroups = [
  {
    id: 'words',
    title: 'Word Practice',
    subtitle: 'Build clean sounds first',
    levels: [
      { id: 1, label: 'Very Easy Words', type: 'word', target: 'cat', focus: 'short clear vowel' },
      { id: 2, label: 'Easy Words', type: 'word', target: 'water', focus: 'w sound and ending clarity' },
      { id: 3, label: 'Medium Words', type: 'word', target: 'village', focus: 'v/w distinction' },
      { id: 4, label: 'Hard Words', type: 'word', target: 'important', focus: 'stress on second syllable' },
      { id: 5, label: 'Very Hard Words', type: 'word', target: 'pronunciation', focus: 'stress and syllable control' }
    ]
  },
  {
    id: 'phrases',
    title: 'Phrase Practice',
    subtitle: 'Connect words naturally',
    levels: [
      { id: 6, label: 'Easy Phrases', type: 'phrase', target: 'thank you', focus: 'th sound without rushing' },
      { id: 7, label: 'Medium Phrases', type: 'phrase', target: 'nice to meet you', focus: 'smooth linking' },
      { id: 8, label: 'Hard Phrases', type: 'phrase', target: 'I would like to explain', focus: 'rhythm and confidence' }
    ]
  },
  {
    id: 'sentences',
    title: 'Sentence Practice',
    subtitle: 'Speak complete thoughts',
    levels: [
      { id: 9, label: 'Easy Sentences', type: 'sentence', target: 'I am learning to speak clearly.', focus: 'steady pace' },
      { id: 10, label: 'Medium Sentences', type: 'sentence', target: 'Communication is very important for interviews.', focus: 'word stress' },
      { id: 11, label: 'Hard Sentences', type: 'sentence', target: 'I can explain my project with confidence and clarity.', focus: 'continuation without fumbling' }
    ]
  },
  {
    id: 'paragraph',
    title: 'Short Paragraph',
    subtitle: 'Practice continuous speech',
    levels: [
      {
        id: 12,
        label: 'Short Paragraph',
        type: 'paragraph',
        target: 'Good morning. My name is Arpit. I am practicing spoken English so I can speak clearly in interviews and presentations.',
        focus: 'confidence, pace, and sentence flow'
      }
    ]
  }
];

export const allLevels = levelGroups.flatMap((group) =>
  group.levels.map((level) => ({ ...level, groupId: group.id, groupTitle: group.title }))
);

export function getLevel(levelId) {
  return allLevels.find((level) => level.id === Number(levelId)) || allLevels[0];
}
