-- ============================================================
-- PopLar CRM — Supabase Setup
-- Execute no SQL Editor do seu projeto Supabase
-- ============================================================

-- LEADS
create table if not exists leads (
  id uuid default gen_random_uuid() primary key,
  nome text not null,
  email text,
  telefone text,
  origem text default 'Site',
  status text default 'Novo',
  imovel text,
  valor text,
  notas text,
  data date default current_date,
  created_at timestamptz default now()
);

-- CONTATOS
create table if not exists contatos (
  id uuid default gen_random_uuid() primary key,
  nome text not null,
  tipo text default 'Lead',
  email text,
  telefone text,
  cidade text,
  tags text[] default '{}',
  created_at timestamptz default now()
);

-- IMÓVEIS
create table if not exists imoveis (
  id uuid default gen_random_uuid() primary key,
  titulo text not null,
  tipo text,
  cidade text,
  bairro text,
  valor text,
  area text,
  quartos int default 0,
  banheiros int default 0,
  vagas int default 0,
  status text default 'Disponível',
  proprietario text,
  destaque boolean default false,
  created_at timestamptz default now()
);

-- AGENDA
create table if not exists agenda (
  id uuid default gen_random_uuid() primary key,
  titulo text not null,
  tipo text,
  data date,
  hora text,
  local text,
  contato text,
  imovel text,
  status text default 'Pendente',
  notas text,
  created_at timestamptz default now()
);

-- ATENDIMENTOS
create table if not exists atendimentos (
  id uuid default gen_random_uuid() primary key,
  tipo text,
  contato text,
  data date,
  hora text,
  duracao text,
  resumo text,
  status text default 'Concluído',
  proximo text,
  created_at timestamptz default now()
);

-- POLÍTICAS (acesso público simplificado para desenvolvimento)
alter table leads        enable row level security;
alter table contatos     enable row level security;
alter table imoveis      enable row level security;
alter table agenda       enable row level security;
alter table atendimentos enable row level security;

create policy "acesso publico leads"        on leads        for all using (true) with check (true);
create policy "acesso publico contatos"     on contatos     for all using (true) with check (true);
create policy "acesso publico imoveis"      on imoveis      for all using (true) with check (true);
create policy "acesso publico agenda"       on agenda       for all using (true) with check (true);
create policy "acesso publico atendimentos" on atendimentos for all using (true) with check (true);

-- ── DADOS INICIAIS ──────────────────────────────────────────

insert into leads (nome, email, telefone, origem, status, imovel, valor, data, notas) values
('Carlos Mendes',  'carlos@email.com',   '(11) 99234-5678', 'Site',      'Novo',           'Apto 3 quartos – Moema',       'R$ 850.000',   '2026-06-20', 'Procura apartamento perto do metrô'),
('Ana Rodrigues',  'ana.r@email.com',    '(11) 98765-4321', 'Indicação', 'Contato',        'Casa 4 quartos – Morumbi',     'R$ 1.200.000', '2026-06-18', 'Financiamento pré-aprovado'),
('Roberto Lima',   'roberto@email.com',  '(21) 97654-3210', 'Instagram', 'Visita Agendada','Studio – Pinheiros',           'R$ 320.000',   '2026-06-15', 'Visita marcada p/ sábado 11h'),
('Fernanda Costa', 'fernanda@email.com', '(11) 96543-2109', 'Portais',   'Proposta',       'Apto 2 quartos – Jardins',     'R$ 650.000',   '2026-06-10', 'Proposta de R$ 620k enviada'),
('Marcelo Santos', 'marcelo@email.com',  '(11) 95432-1098', 'Site',      'Fechado',        'Cobertura – Itaim Bibi',       'R$ 2.100.000', '2026-06-05', 'Escritura em 15/07'),
('Juliana Alves',  'juliana@email.com',  '(11) 94321-0987', 'Indicação', 'Perdido',        'Apto 1 quarto – Vila Madalena','R$ 280.000',   '2026-06-01', 'Optou por outra imobiliária'),
('Paulo Ferreira', 'paulo.f@email.com',  '(21) 93210-9876', 'Google',    'Novo',           'Casa 3 quartos – Barra',       'R$ 980.000',   '2026-06-22', 'Formulário do site'),
('Marcia Oliveira','marcia@email.com',   '(11) 92109-8765', 'Site',      'Contato',        'Terreno – Alphaville',         'R$ 450.000',   '2026-06-19', 'Interesse em terreno');

insert into contatos (nome, tipo, email, telefone, cidade, tags) values
('Carlos Mendes',    'Lead',        'carlos@email.com',   '(11) 99234-5678', 'São Paulo',     ARRAY['Comprador','Financiamento']),
('Ana Rodrigues',    'Cliente',     'ana.r@email.com',    '(11) 98765-4321', 'São Paulo',     ARRAY['VIP','Comprador']),
('Roberto Lima',     'Lead',        'roberto@email.com',  '(21) 97654-3210', 'Rio de Janeiro',ARRAY['Investidor']),
('Fernanda Costa',   'Lead',        'fernanda@email.com', '(11) 96543-2109', 'São Paulo',     ARRAY['Comprador']),
('Marcelo Santos',   'Cliente',     'marcelo@email.com',  '(11) 95432-1098', 'São Paulo',     ARRAY['VIP','Fechado']),
('João Proprietário','Proprietário','joao.p@email.com',   '(11) 94567-8901', 'São Paulo',     ARRAY['Proprietário']),
('Maria Proprietária','Proprietária','maria.p@email.com', '(21) 93456-7890', 'Rio de Janeiro',ARRAY['Proprietária','VIP']),
('Paulo Ferreira',   'Lead',        'paulo.f@email.com',  '(21) 93210-9876', 'Rio de Janeiro',ARRAY['Comprador']),
('Marcia Oliveira',  'Lead',        'marcia@email.com',   '(11) 92109-8765', 'São Paulo',     ARRAY['Investidor']),
('Luiz Corretor',    'Parceiro',    'luiz.c@email.com',   '(11) 91098-7654', 'São Paulo',     ARRAY['Parceiro']);

insert into imoveis (titulo, tipo, cidade, bairro, valor, area, quartos, banheiros, vagas, status, proprietario, destaque) values
('Apartamento 3 quartos – Moema',    'Apartamento','São Paulo',     'Moema',          'R$ 850.000',   '95m²',  3, 2, 2, 'Disponível', 'João Proprietário',  true),
('Casa 4 quartos – Morumbi',         'Casa',       'São Paulo',     'Morumbi',        'R$ 1.200.000', '220m²', 4, 3, 3, 'Disponível', 'Maria Proprietária', true),
('Studio – Pinheiros',               'Apartamento','São Paulo',     'Pinheiros',      'R$ 320.000',   '38m²',  1, 1, 1, 'Reservado',  'João Proprietário',  false),
('Apartamento 2 quartos – Jardins',  'Apartamento','São Paulo',     'Jardins',        'R$ 650.000',   '72m²',  2, 2, 1, 'Disponível', 'Maria Proprietária', false),
('Cobertura – Itaim Bibi',           'Cobertura',  'São Paulo',     'Itaim Bibi',     'R$ 2.100.000', '310m²', 4, 4, 4, 'Vendido',    'João Proprietário',  false),
('Casa 3 quartos – Barra da Tijuca', 'Casa',       'Rio de Janeiro','Barra da Tijuca','R$ 980.000',   '180m²', 3, 3, 2, 'Disponível', 'Maria Proprietária', true),
('Terreno – Alphaville',             'Terreno',    'São Paulo',     'Alphaville',     'R$ 450.000',   '500m²', 0, 0, 0, 'Disponível', 'João Proprietário',  false),
('Apto 1 quarto – Vila Madalena',    'Apartamento','São Paulo',     'Vila Madalena',  'R$ 280.000',   '45m²',  1, 1, 1, 'Disponível', 'Maria Proprietária', false);

insert into agenda (titulo, tipo, data, hora, local, contato, imovel, status, notas) values
('Visita – Carlos Mendes',     'Visita',    '2026-06-28','10:00','Rua das Flores, 123 – Moema',   'Carlos Mendes',    'Apto 3 quartos – Moema',  'Confirmado','Levar planta baixa'),
('Reunião – Ana Rodrigues',    'Reunião',   '2026-06-28','14:30','Escritório PopLar',              'Ana Rodrigues',    'Casa 4 quartos – Morumbi','Confirmado','Apresentar proposta final'),
('Visita – Roberto Lima',      'Visita',    '2026-06-29','11:00','Rua Augusta, 456 – Pinheiros',  'Roberto Lima',     'Studio – Pinheiros',      'Pendente',  ''),
('Assinatura – Marcelo Santos','Assinatura','2026-07-15','09:00','Cartório Central',               'Marcelo Santos',   'Cobertura – Itaim Bibi',  'Confirmado','RG, CPF e comprovante'),
('Avaliação – João Proprietário','Avaliação','2026-06-30','16:00','Av. Paulista, 789 – Jardins',  'João Proprietário','Apto 2 quartos – Jardins', 'Pendente',  'Fazer relatório de avaliação');

insert into atendimentos (tipo, contato, data, hora, duracao, resumo, status, proximo) values
('Ligação',  'Carlos Mendes', '2026-06-20','09:30','15 min',  'Primeiro contato. Cliente procura apto 3 quartos perto do metrô. Budget até R$900k.','Concluído','Enviar opções por e-mail'),
('Email',    'Ana Rodrigues', '2026-06-18','11:00','–',       'Envio de 3 opções de imóveis no Morumbi. Cliente tem financiamento pré-aprovado.',   'Concluído','Aguardar retorno'),
('WhatsApp', 'Roberto Lima',  '2026-06-22','14:15','8 min',   'Confirmação da visita ao studio em Pinheiros para sábado às 11h.',                   'Concluído','Confirmar visita'),
('Visita',   'Fernanda Costa','2026-06-21','10:00','45 min',  'Visita ao apartamento nos Jardins. Gostou mas pediu desconto de R$30k.',              'Concluído','Negociar com proprietária'),
('Reunião',  'Marcelo Santos','2026-06-05','15:00','1h 30min','Fechamento. Valor final: R$2.050.000. Escritura em 15/07.',                           'Concluído','Escritura 15/07'),
('Ligação',  'Paulo Ferreira','2026-06-22','17:30','10 min',  'Interesse em casa na Barra com 3 quartos e piscina.',                                 'Concluído','Agendar visita');
