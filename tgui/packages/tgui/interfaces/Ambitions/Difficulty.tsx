import type { CSSProperties } from 'react';

const labels = ['Быстрая цель', 'Потребует времени', 'На весь раунд'];

type Props = {
  value: number;
  onChange?: (value: number) => void;
  layout?: 'row' | 'column';
  accent?: string;
};

export function Difficulty({
  value,
  onChange,
  layout = 'row',
  accent = '#b9c8dc',
}: Props) {
  const level = Math.max(1, Math.min(3, value));

  return (
    <div
      style={{
        display: 'inline-flex',
        flexDirection: layout,
        alignItems: layout === 'row' ? 'center' : 'flex-start',
        maxWidth: '100%',
        boxSizing: 'border-box',
        gap: '7px',
        padding: '10px 12px',
        borderRadius: '6px',
        background: 'rgba(0,0,0,.2)',
        border: '1px solid rgba(255,255,255,.1)',
      }}
    >
      <div style={{ color: '#cbd5df' }}>СЛОЖНОСТЬ</div>
      <div
        role={onChange ? 'group' : 'meter'}
        aria-label="Сложность амбиции"
        aria-valuemin={onChange ? undefined : 1}
        aria-valuemax={onChange ? undefined : 3}
        aria-valuenow={onChange ? undefined : level}
        aria-valuetext={onChange ? undefined : labels[level - 1]}
        style={{ display: 'flex', alignItems: 'center', gap: '5px' }}
      >
        {[1, 2, 3].map((segment) => {
          const style: CSSProperties = {
            display: 'block',
            width: '10px',
            height: '10px',
            padding: 0,
            borderRadius: '3px',
            border: '1px solid rgba(255,255,255,.15)',
            background: segment <= level ? accent : 'rgba(255,255,255,.08)',
            boxShadow: segment <= level ? `0 0 7px ${accent}33` : 'none',
          };
          return onChange ? (
            <button
              key={segment}
              type="button"
              aria-label={`Сложность ${segment}: ${labels[segment - 1]}`}
              aria-pressed={segment === level}
              title={labels[segment - 1]}
              onClick={() => onChange(segment)}
              style={{
                ...style,
                height: '18px',
                width: '18px',
                cursor: 'pointer',
              }}
            />
          ) : (
            <span key={segment} style={style} />
          );
        })}
      </div>
      <div style={{ color: accent, fontSize: '12px' }}>{labels[level - 1]}</div>
    </div>
  );
}
