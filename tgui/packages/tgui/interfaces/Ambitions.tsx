import { useState } from 'react';
import {
  Box,
  Button,
  Input,
  Modal,
  NumberInput,
  Section,
  TextArea,
} from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  type AdminColor,
  type AmbitionSource,
  adminColors,
  getAmbitionAppearance,
} from './Ambitions/appearance';
import { Difficulty } from './Ambitions/Difficulty';

type Ambition = {
  id: number;
  ref: string;
  title: string;
  description: string;
  difficulty: number;
  completed: boolean;
  source: AmbitionSource;
  takers?: string[];
  participantLimit?: number;
  participantCount?: number;
  cardColor?: AdminColor;
};

type Data = {
  ambitions: Ambition[];
  offers: Ambition[];
  adminOffers: Ambition[];
  maxAmbitions: number;
  maxLength: number;
  maxTitleLength: number;
  characterName: string;
  adminMode: boolean;
  poolMode: boolean;
};

type Act = (action: string, params?: Record<string, string | number>) => void;
type Draft = {
  title: string;
  description: string;
  difficulty: number;
  participantLimit: number;
  cardColor: AdminColor;
};

function AmbitionEditor(props: {
  ambition?: Ambition;
  poolMode: boolean;
  maxLength: number;
  maxTitleLength: number;
  onSave: (draft: Draft) => void;
  onClose: () => void;
}) {
  const { ambition, poolMode, maxLength, maxTitleLength, onSave, onClose } =
    props;
  const [title, setTitle] = useState(ambition?.title ?? '');
  const [description, setDescription] = useState(ambition?.description ?? '');
  const [difficulty, setDifficulty] = useState(ambition?.difficulty ?? 1);
  const [participantLimit, setParticipantLimit] = useState(
    ambition?.participantLimit ?? 0,
  );
  const [cardColor, setCardColor] = useState<AdminColor>(
    ambition?.cardColor ?? 'purple',
  );
  const appearance = getAmbitionAppearance(
    ambition?.source ?? (poolMode ? 'admin' : 'custom'),
    poolMode ? cardColor : ambition?.cardColor,
  );

  return (
    <Modal width="550px">
      <Section
        title={ambition ? 'Изменить амбицию' : 'Создать амбицию'}
        buttons={
          <Button icon="times" onClick={onClose}>
            Закрыть
          </Button>
        }
      >
        <div style={{ display: 'flex', flexDirection: 'column', gap: '12px' }}>
          <div>
            <Box mb={1} color="label">
              Заголовок
            </Box>
            <Input
              fluid
              value={title}
              maxLength={maxTitleLength}
              onChange={setTitle}
            />
          </div>
          <div>
            <Box mb={1} color="label">
              Описание
            </Box>
            <TextArea
              fluid
              height="130px"
              value={description}
              maxLength={maxLength}
              onChange={setDescription}
            />
          </div>
          <Difficulty
            value={difficulty}
            accent={appearance.accent}
            layout="column"
            onChange={setDifficulty}
          />
          {!!poolMode && (
            <>
              <div>
                <Box mb={1} color="label">
                  Лимит участников · 0 — без ограничений
                </Box>
                <NumberInput
                  value={participantLimit}
                  minValue={0}
                  step={1}
                  onChange={(value) =>
                    setParticipantLimit(Math.max(0, Math.round(value)))
                  }
                />
                <Box mt={1} color="label">
                  При заполнении предложение скрывается из выбора. Уже взятые
                  амбиции сохраняются.
                </Box>
              </div>
              <div>
                <Box mb={1} color="label">
                  Цвет карточки
                </Box>
                <div style={{ display: 'flex', flexWrap: 'wrap', gap: '6px' }}>
                  {(Object.keys(adminColors) as AdminColor[]).map((color) => (
                    <Button
                      key={color}
                      selected={cardColor === color}
                      onClick={() => setCardColor(color)}
                    >
                      <span
                        style={{
                          display: 'inline-block',
                          width: '10px',
                          height: '10px',
                          marginRight: '6px',
                          borderRadius: '3px',
                          background: adminColors[color].accent,
                        }}
                      />
                      {adminColors[color].label}
                    </Button>
                  ))}
                </div>
              </div>
            </>
          )}
          {!!poolMode && ambition && (
            <Box color="label">
              Изменения получат все игроки, взявшие это предложение.
            </Box>
          )}
          <Button
            fluid
            icon="save"
            disabled={!title.trim() || !description.trim()}
            onClick={() =>
              onSave({
                title,
                description,
                difficulty,
                participantLimit,
                cardColor,
              })
            }
          >
            Сохранить
          </Button>
        </div>
      </Section>
    </Modal>
  );
}

function AmbitionCard(props: {
  ambition: Ambition;
  poolMode: boolean;
  act: Act;
  onEdit: () => void;
}) {
  const { ambition, poolMode, act, onEdit } = props;
  const appearance = getAmbitionAppearance(ambition.source, ambition.cardColor);
  return (
    <div
      style={{
        display: 'grid',
        gridTemplateColumns: 'minmax(0, 1fr) 165px 115px',
        alignItems: 'start',
        gap: '16px',
        padding: '16px',
        marginBottom: '10px',
        borderRadius: '7px',
        border: `1px solid ${appearance.accent}44`,
        background: appearance.background,
        color: '#fff',
        textAlign: 'left',
      }}
    >
      <div style={{ minWidth: 0, overflowWrap: 'anywhere' }}>
        <Box bold fontSize="18px" mb={0.5}>
          {ambition.title}
        </Box>
        <Box color={appearance.accent} fontSize="11px" mb={1}>
          {appearance.label}
        </Box>
        <div style={{ whiteSpace: 'pre-wrap', lineHeight: 1.4 }}>
          {ambition.description}
        </div>
        {!!poolMode && (
          <Box mt={2} color="label">
            Участники: {ambition.participantCount ?? 0} /{' '}
            {ambition.participantLimit || '∞'}
            {!!ambition.participantLimit &&
              (ambition.participantCount ?? 0) >= ambition.participantLimit &&
              ' · Скрыта из выбора'}
            <br />
            Взяли:{' '}
            {ambition.takers?.length
              ? ambition.takers.join(', ')
              : 'пока никто'}
          </Box>
        )}
      </div>
      <Difficulty
        value={ambition.difficulty}
        accent={appearance.accent}
        layout="column"
      />
      <div style={{ display: 'flex', flexDirection: 'column', gap: '5px' }}>
        {!poolMode && (
          <Button
            fluid
            icon={ambition.completed ? 'check-circle' : 'check'}
            selected={ambition.completed}
            color={ambition.completed ? 'good' : undefined}
            tooltip={
              ambition.completed
                ? 'Снять отметку выполнения'
                : 'Отметить выполнение для себя'
            }
            onClick={() => act('toggle_completed', { ref: ambition.ref })}
          >
            {ambition.completed ? 'Выполнено' : 'Выполнить'}
          </Button>
        )}
        <Button fluid icon="pen" onClick={onEdit}>
          Изменить
        </Button>
        <Button
          fluid
          icon="trash"
          color="bad"
          onClick={() => act('remove', { ref: ambition.ref })}
        >
          Удалить
        </Button>
      </div>
    </div>
  );
}

function OfferCard(props: { ambition: Ambition; onChoose: () => void }) {
  const { ambition, onChoose } = props;
  const appearance = getAmbitionAppearance(ambition.source, ambition.cardColor);
  return (
    <div
      style={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'stretch',
        gap: '12px',
        padding: '16px',
        height: '100%',
        minHeight: '285px',
        boxSizing: 'border-box',
        borderRadius: '7px',
        border: `1px solid ${appearance.accent}44`,
        background: appearance.background,
        color: '#fff',
        textAlign: 'left',
        overflowWrap: 'anywhere',
      }}
    >
      <Box bold fontSize="18px">
        {ambition.title}
      </Box>
      <Difficulty
        value={ambition.difficulty}
        accent={appearance.accent}
        layout="column"
      />
      <div style={{ flex: 1, whiteSpace: 'pre-wrap', lineHeight: 1.4 }}>
        {ambition.description}
      </div>
      <Button fluid icon="plus" onClick={onChoose}>
        Выбрать
      </Button>
    </div>
  );
}

function CreationButtons(props: {
  poolMode: boolean;
  onRandom: () => void;
  onCustom: () => void;
  onAdmin: () => void;
}) {
  const { poolMode, onRandom, onCustom, onAdmin } = props;
  return (
    <div
      style={{
        display: 'flex',
        flexWrap: 'wrap',
        justifyContent: 'center',
        gap: '8px',
      }}
    >
      {!poolMode && (
        <Button icon="compass" onClick={onRandom}>
          Случайная амбиция
        </Button>
      )}
      <Button icon="plus" onClick={onCustom}>
        {poolMode ? 'Добавить свою амбицию' : 'Своя амбиция'}
      </Button>
      {!poolMode && (
        <Button icon="user-shield" onClick={onAdmin}>
          От админа
        </Button>
      )}
    </div>
  );
}

export function Ambitions() {
  const { act, data } = useBackend<Data>();
  const {
    ambitions = [],
    offers = [],
    adminOffers = [],
    maxAmbitions = 5,
    maxLength = 500,
    maxTitleLength = 80,
    characterName,
    adminMode,
    poolMode,
  } = data;
  const [editor, setEditor] = useState<Ambition | 'new' | null>(null);
  const [catalogue, setCatalogue] = useState(false);
  const isFull = !poolMode && ambitions.length >= maxAmbitions;
  const title = poolMode
    ? 'Пул амбиций от администрации'
    : adminMode
      ? `Амбиции — ${characterName}`
      : 'Амбиции';
  const creationActions = {
    poolMode,
    onRandom: () => act('find'),
    onCustom: () => setEditor('new'),
    onAdmin: () => setCatalogue(true),
  };
  const edited = editor && editor !== 'new' ? editor : undefined;
  // A record removed by another window should not remain editable here.
  const showEditor =
    editor === 'new' ||
    (edited && ambitions.some((entry) => entry.ref === edited.ref));

  return (
    <Window title={title} width={880} height={670}>
      <Window.Content scrollable>
        <Section
          title={
            poolMode
              ? 'Предложения игрокам'
              : `Лимит амбиций · ${ambitions.length}/${maxAmbitions}`
          }
        >
          <Box mb={2} color="label">
            {poolMode ? (
              'Здесь можно создать предложения амбиций для игроков. Они смогут выбрать их из специальной владки. Постарайтесь избегать мета-информации в описании.'
            ) : (
              <>
                <Box mb={1}>
                  <b>Амбиции</b> — это необязательные РП-цели на раунд. В
                  отличие от целей антагонистов, они не дают вам право на гриф
                  или убийства, но могут помочь придумать, чем заняться в
                  раунде.
                </Box>

                <Box mb={1}>
                  Вы можете <b>создать свою амбицию</b> или{' '}
                  <b>выбрать случайную</b> из заранее заготовленных
                  разработчиками или администрацией.
                </Box>

                <Box mb={1}>
                  После выбора вы можете <b>изменить</b> амбицию,{' '}
                  <b>отказаться</b> от неё или <b>взять новую</b>.
                </Box>
                <Box mb={1}>
                  В конце раунда все активные амбиции игроков будут отображены в
                  отчёте о раунде.
                </Box>
              </>
            )}
          </Box>
        </Section>
        {ambitions.map((ambition) => (
          <AmbitionCard
            key={ambition.ref}
            ambition={ambition}
            poolMode={poolMode}
            act={act}
            onEdit={() => setEditor(ambition)}
          />
        ))}
        {!isFull ? (
          <div
            style={{
              padding: '28px 16px',
              borderRadius: '7px',
              border: '1px dashed rgba(175,194,218,.35)',
              background: 'rgba(72,93,123,.16)',
              textAlign: 'center',
            }}
          >
            <Box mb={2} color="label">
              {poolMode ? 'Новое предложение' : 'Новая амбиция'}
            </Box>
            <CreationButtons {...creationActions} />
          </div>
        ) : (
          <Box color="label" p={2}>
            Достигнут лимит. Удалите одну амбицию, чтобы взять новую.
          </Box>
        )}
        {showEditor && (
          <AmbitionEditor
            key={edited?.ref ?? 'new'}
            ambition={edited}
            poolMode={poolMode}
            maxLength={maxLength}
            maxTitleLength={maxTitleLength}
            onClose={() => setEditor(null)}
            onSave={(draft) => {
              act(
                edited ? 'edit' : 'add',
                edited ? { ...draft, ref: edited.ref } : draft,
              );
              setEditor(null);
            }}
          />
        )}
        {offers.length > 0 && (
          <Modal width="810px" align="center">
            <Section
              title="Выберите новую амбицию"
              buttons={
                <>
                  <Button icon="dice" onClick={() => act('find')}>
                    Реролл
                  </Button>
                  <Button icon="times" onClick={() => act('cancel')}>
                    Закрыть
                  </Button>
                </>
              }
            >
              <div
                style={{
                  display: 'grid',
                  gridTemplateColumns: `repeat(${offers.length}, minmax(0, 1fr))`,
                  gap: '12px',
                }}
              >
                {offers.map((offer) => (
                  <OfferCard
                    key={offer.ref}
                    ambition={offer}
                    onChoose={() => act('choose', { index: offer.id })}
                  />
                ))}
              </div>
            </Section>
          </Modal>
        )}
        {catalogue && (
          <Modal width="810px" align="center">
            <Section
              title="Амбиции от администрации"
              buttons={
                <Button icon="times" onClick={() => setCatalogue(false)}>
                  Закрыть
                </Button>
              }
            >
              {!adminOffers.length && (
                <Box color="label">
                  Сейчас нет доступных предложений от администрации.
                </Box>
              )}
              <div style={{ maxHeight: '460px', overflowY: 'auto' }}>
                <div
                  style={{
                    display: 'grid',
                    gridTemplateColumns: 'repeat(3, minmax(0, 1fr))',
                    gap: '12px',
                  }}
                >
                  {adminOffers.map((offer) => (
                    <OfferCard
                      key={offer.ref}
                      ambition={offer}
                      onChoose={() => {
                        act('choose_admin', { ref: offer.ref });
                        setCatalogue(false);
                      }}
                    />
                  ))}
                </div>
              </div>
            </Section>
          </Modal>
        )}
      </Window.Content>
    </Window>
  );
}
