export type AmbitionSource = 'general' | 'job' | 'custom' | 'admin';

const appearances = {
  general: { background: '#293e59', accent: '#8dbdf5', label: 'Общая' },
  job: { background: '#254638', accent: '#78d9ae', label: 'По профессии' },
  custom: { background: '#512f37', accent: '#efa0aa', label: 'Своя' },
  admin: { background: '#443151', accent: '#dfa5e8', label: 'От админа' },
};

export const adminColors = {
  blue: { background: '#293e59', accent: '#8dbdf5', label: 'Синий' },
  green: { background: '#254638', accent: '#78d9ae', label: 'Зелёный' },
  red: { background: '#512f37', accent: '#efa0aa', label: 'Красный' },
  purple: { background: '#443151', accent: '#dfa5e8', label: 'Фиолетовый' },
  amber: { background: '#51432b', accent: '#edc47e', label: 'Золотой' },
  teal: { background: '#25464a', accent: '#7fd3db', label: 'Бирюзовый' },
};

export type AdminColor = keyof typeof adminColors;

export function getAmbitionAppearance(
  source: AmbitionSource,
  color?: AdminColor,
) {
  const appearance = appearances[source] ?? appearances.custom;
  return source === 'admin' && color && adminColors[color]
    ? { ...adminColors[color], label: appearance.label }
    : appearance;
}
