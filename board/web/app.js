'use strict';
// The outreach board. State lives in the URL hash (so a view can be shared as a link), data comes from /api, and the
// DOM is built with h(), which sets registry text and comments as text. The one exception is a card's What happens and
// Evidence: md() escapes them first and then adds links, code and bullets.

const MORE = [['category', 'Category'], ['pattern', 'Pattern'], ['impact', 'Impact'], ['upgradeable', 'Upgradeable'],
  ['study', 'Study'], ['level', 'Level'], ['gap', 'Missing data']];
const FILTERS = ['severity', 'status', 'assignee', 'comments', ...MORE.map(m => m[0])];
const EXACT = { project: 'Project', deployer: 'Deployer' };  // one value: a team's or a deployer's findings
const COLUMNS = [['severity', 'Severity'], ['title', 'Finding'], ['value', 'Held now', 'n'], ['status', 'Outreach'],
  ['assignee', 'Assignee'], ['comments', 'Comments'], ['updated', 'Updated']];
const SORTS = { severity: 'severity', value: 'held now', registry: 'card value (held, escrow, market cap)', txs: 'activity (90 days)',
  updated: 'latest outreach change', comments: 'number of comments', status: 'outreach status', assignee: 'assignee', title: 'title' };
const S = { q: '', f: {}, x: {}, min: '', sort: 'severity', dir: 'asc', page: 0, size: 50, open: '' };
const picked = new Set();
let META, lastStats = null, statsKey = null, seq = 0, total = 0, pageIds = [], openDD = '';

// ---------- helpers ----------
const $ = s => document.querySelector(s);
function h(tag, attrs, ...kids) {
  const el = document.createElement(tag);
  for (const [k, v] of Object.entries(attrs || {})) {
    if (v == null || v === false) continue;
    if (k.startsWith('on')) el.addEventListener(k.slice(2), v);
    else if (k === 'class') el.className = v;
    else if (k === 'html') el.innerHTML = v;  // md() output only
    else if (k in el && typeof v !== 'string') el[k] = v;
    else el.setAttribute(k, v === true ? '' : v);
  }
  if (kids.length) fill(el, ...kids);  // not over `html`
  return el;
}
// replaceChildren() that, like h(), flattens arrays and drops null, false and ''
function fill(el, ...kids) {
  el.replaceChildren(...kids.flat(Infinity).filter(k => k != null && k !== false && k !== '').map(k => k instanceof Node ? k : String(k)));
  return el;
}
const num = n => n == null ? '' : Number(n).toLocaleString('en-US');
const money = v => v == null ? '' : v >= 1e9 ? `$${(v / 1e9).toFixed(1)}B` : v >= 1e6 ? `$${(v / 1e6).toFixed(1)}M`
  : v >= 1e3 ? `$${Math.round(v / 1e3)}k` : `$${Math.round(v)}`;
const short = a => /^0x[0-9a-f]{40}$/.test(a || '') ? a.slice(0, 8) + '…' + a.slice(-4) : a;
const holdingsText = (json, n = 3) => JSON.parse(json || '[]').slice(0, n).map(([s, , usd]) => `${s} ${money(+usd)}`).join(' · ');
function ago(iso) {
  const s = (Date.now() - Date.parse(iso)) / 1000;
  return s < 60 ? 'just now' : s < 3600 ? `${Math.floor(s / 60)}m ago` : s < 86400 ? `${Math.floor(s / 3600)}h ago` : `${Math.floor(s / 86400)}d ago`;
}
const when = iso => iso ? new Date(iso).toLocaleString() : '';
const sevPill = s => h('span', { class: `sev c-${s}` }, s);
const statusPill = s => h('span', { class: `stp s-${s}` }, h('i', { class: 'dot' }), s);
const link = (href, text) => h('a', { href, target: '_blank', rel: 'noopener noreferrer' }, text);
const etherscan = a => h('a', { href: `https://etherscan.io/address/${a}`, target: '_blank', rel: 'noopener noreferrer', title: a }, h('code', {}, short(a)));
function toast(msg, err) {
  const t = $('#toast');
  t.textContent = msg; t.className = 'toast' + (err ? ' err' : ''); t.hidden = false;
  clearTimeout(toast.timer); toast.timer = setTimeout(() => { t.hidden = true; }, err ? 7000 : 2500);
}
async function api(path, body) {
  // location.origin drops user:password@ from the address, which fetch() refuses
  const r = await fetch(location.origin + path, body === undefined ? {} :
    { method: 'PATCH', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(body) });
  const data = await r.json().catch(() => ({ error: `${r.status} ${r.statusText}` }));
  if (!r.ok) throw new Error(data.error || r.statusText);
  return data;
}
const copyBtn = text => h('button', { class: 'icon', title: 'Copy', 'aria-label': 'Copy', onclick: async e => {
  e.stopPropagation();
  try { await navigator.clipboard.writeText(text); toast('Copied'); } catch { toast('Copy failed: select it and copy by hand', true); }
} }, 'copy');
// A comment as text, its links clickable.
function linkify(text) {
  const out = [];
  let last = 0;
  for (const m of text.matchAll(/https?:\/\/[^\s<>"')\]]+/g)) {
    out.push(text.slice(last, m.index), link(m[0], m[0]));
    last = m.index + m[0].length;
  }
  return [...out, text.slice(last)];
}
function valueLabel(key, v) {
  if (key === 'pattern') return `${v} · ${META.patterns[v]?.title || ''}`;
  if (key === 'category') return META.categories[v] || v || '(none)';
  return v || '(none)';
}
function valueTitle(key, v) {
  if (key === 'gap') return META.gaps[v] || v;
  if (key === 'study') return META.studies[v] || v;
  if (key === 'status') return META.status_help[v] || v;
  return null;
}
function valueTip(r) {
  return (r.held_at ? `Held on ${r.held_at} in ETH and every priced token, at this address`
    + (r.holdings ? `\n${holdingsText(r.holdings, 5)}` : '')
    + (r.family_held != null ? `\nSame code: ${num(r.family_addresses)} addresses hold ${money(r.family_held)}` : '') + '\n' : '')
    + (r.value_usd != null ? `Card: ${money(r.value_usd)} ${r.value_basis || ''}` : '');
}

// ---------- card text: paragraphs and bullets with inline code, links and bold (AGENTS.md allows no more) ----------
const esc = s => s.replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
const INLINE = /`([^`]+)`|\[((?:`[^`]*`|[^\]])+)\]\((https?:\/\/[^)\s]+)\)|\*\*(.+?)\*\*|<(https?:\/\/[^>\s]+)>/g;
function inline(s) {
  let out = '', last = 0;
  for (const m of s.matchAll(INLINE)) {
    out += esc(s.slice(last, m.index));
    last = m.index + m[0].length;
    const a = url => `<a href="${esc(url)}" target="_blank" rel="noopener noreferrer">`;
    if (m[1] != null) out += `<code>${esc(m[1])}</code>`;
    else if (m[2] != null) out += a(m[3]) + inline(m[2]) + '</a>';
    else if (m[4] != null) out += `<strong>${inline(m[4])}</strong>`;
    else out += a(m[5]) + esc(m[5]) + '</a>';
  }
  return out + esc(s.slice(last));
}
function md(src) {
  return src.split(/\n\s*\n/).map(block => {
    const lines = block.split('\n');
    if (!/^\s*[-*] /.test(lines[0])) return `<p>${inline(lines.map(l => l.trim()).join(' '))}</p>`;
    const items = [];
    for (const l of lines) {
      if (/^\s*[-*] /.test(l)) items.push(l.replace(/^\s*[-*] /, ''));
      else if (items.length) items[items.length - 1] += ' ' + l.trim();
    }
    return '<ul>' + items.map(t => `<li>${inline(t)}</li>`).join('') + '</ul>';
  }).join('');
}

// ---------- state <-> URL ----------
function readHash() {
  const p = new URLSearchParams(location.hash.slice(1));
  S.q = p.get('q') || ''; S.min = p.get('min_value') || '';
  S.f = {}; S.x = {};
  for (const k of FILTERS) if (p.get(k)) S.f[k] = p.get(k).split(',');
  for (const k in EXACT) if (p.get(k)) S.x[k] = p.get(k);
  S.sort = p.get('sort') || 'severity'; S.dir = p.get('dir') || 'asc';
  S.page = +p.get('page') || 0; S.size = +p.get('size') || 50;
  S.open = p.get('open') || '';
  $('#q').value = S.q; $('#min').value = S.min;
}
function params(extra = {}) {
  const p = new URLSearchParams();
  if (S.q) p.set('q', S.q);
  for (const [k, v] of Object.entries(S.f)) if (v.length) p.set(k, v.join(','));
  for (const [k, v] of Object.entries(S.x)) p.set(k, v);
  if (S.min) p.set('min_value', S.min);
  for (const [k, v] of Object.entries(extra)) p.set(k, v);
  return p;
}
function writeHash() {
  const p = params();
  if (S.sort !== 'severity' || S.dir !== 'asc') { p.set('sort', S.sort); p.set('dir', S.dir); }
  if (S.page) p.set('page', S.page);
  if (S.size !== 50) p.set('size', S.size);
  if (S.open) p.set('open', S.open);
  history.replaceState(null, '', p.toString() ? '#' + p : location.pathname);
}
function toggle(key, v) {
  const cur = S.f[key] || [];
  S.f[key] = cur.includes(v) ? cur.filter(x => x !== v) : [...cur, v];
  if (!S.f[key].length) delete S.f[key];
  changed();
}
function clearAll() { S.f = {}; S.x = {}; S.q = ''; S.min = ''; $('#q').value = ''; $('#min').value = ''; changed(); }
function changed() { S.page = 0; picked.clear(); refresh(); }

// ---------- list and filters ----------
async function refresh() {
  writeHash();
  const my = ++seq, key = params().toString();
  try {
    // The list comes back in tens of milliseconds, the counts in a few hundred: draw each when it arrives.
    const stats = key === statsKey ? null : api('/api/stats?' + key);
    stats?.catch(() => {});  // still thrown by `await stats` below, if we get there
    const list = await api('/api/findings?' + params({ sort: S.sort, dir: S.dir, offset: S.page * S.size, limit: S.size }));
    if (my !== seq) return;  // a newer request is on its way
    drawList(list);
    if (!stats) return drawFilters();
    const s = await stats;
    if (my !== seq) return;
    statsKey = key; lastStats = s;
    drawFilters();
  } catch (e) { toast(e.message, true); }
}

// Every value of a filter with its count under the other filters, and the selected ones even when none match.
function counts(key) {
  const sel = S.f[key] || [], list = [...(lastStats?.[key] || [])];
  for (const v of sel) if (!list.some(x => x.v === v)) list.push({ v, n: 0 });
  return list;
}
function chip(key, v, label, n, cls = '') {
  const on = (S.f[key] || []).includes(v);
  return h('button', { class: `chip ${cls}${on ? ' on' : ''}`, 'aria-pressed': String(on), title: valueTitle(key, v), onclick: () => toggle(key, v) },
    label, h('span', { class: 'cn' }, num(n)));
}
function anyChip(key, label) {
  const on = !(S.f[key] || []).length;
  return h('button', { class: 'chip' + (on ? ' on' : ''), 'aria-pressed': String(on), onclick: () => { delete S.f[key]; changed(); } }, label);
}
function dropdown(key, label) {
  const sel = S.f[key] || [], list = counts(key);
  if (!list.length) return null;
  return h('details', {
    class: 'dd' + (sel.length ? ' on' : ''), open: openDD === key,
    ontoggle: e => {
      if (e.target.open) { openDD = key; document.querySelectorAll('details.dd[open]').forEach(d => { if (d !== e.target) d.open = false; }); }
      else if (openDD === key) openDD = '';
    } },
    h('summary', {}, label, sel.length ? h('b', {}, sel.length === 1 ? valueLabel(key, sel[0]) : `${sel.length} selected`) : null),
    h('div', { class: 'dd-panel' },
      list.map(({ v, n }) => h('label', { class: 'dd-opt', title: valueTitle(key, v) },
        h('input', { type: 'checkbox', checked: sel.includes(v), onchange: () => toggle(key, v) }),
        h('span', { class: 'dd-l' }, valueLabel(key, v)), h('span', { class: 'n soft' }, num(n)))),
      sel.length ? h('button', { class: 'link', onclick: () => { delete S.f[key]; changed(); } }, 'Clear') : null));
}
function drawFilters() {
  if (!lastStats) return;
  const by = key => Object.fromEntries(counts(key).map(x => [x.v, x.n]));
  const a = by('assignee'), c = by('comments'), st = by('status'), sv = by('severity');
  const me = META.user, nobody = META.unassigned;
  const others = Object.keys(a).filter(v => v !== me && v !== nobody).sort();
  const all = Object.values(st).reduce((x, y) => x + y, 0), started = all - (st['not-contacted'] || 0);
  const track = h('span', { class: 'track' }, META.statuses.filter(s => s !== 'not-contacted' && st[s]).map(s => {
    const i = h('i', { class: `s-${s}`, title: `${s}: ${num(st[s])}` });
    i.style.width = `${100 * st[s] / Math.max(1, all)}%`;
    return i;
  }));
  fill($('#chips'),
    h('div', { class: 'frow' },
      h('span', { class: 'fl' }, 'Assigned'), anyChip('assignee', 'Anyone'), chip('assignee', me, 'Me', a[me] || 0),
      chip('assignee', nobody, 'Nobody', a[nobody] || 0), others.map(v => chip('assignee', v, v, a[v])),
      h('span', { class: 'fl sep' }, 'Comments'), anyChip('comments', 'Any'),
      chip('comments', 'yes', 'Commented', c.yes || 0), chip('comments', 'no', 'Not commented', c.no || 0)),
    h('div', { class: 'frow' },
      h('span', { class: 'fl' }, 'Outreach'), META.statuses.map(s => chip('status', s, [h('i', { class: 'dot' }), s], st[s] || 0, `s-${s}`)),
      h('span', { class: 'progress', title: 'Findings whose outreach has started, under the other filters' }, track,
        `${num(started)} of ${num(all)} started`)),
    h('div', { class: 'frow' },
      h('span', { class: 'fl' }, 'Severity'), META.severities.filter(s => s in sv || (S.f.severity || []).includes(s))
        .map(s => chip('severity', s, s, sv[s] || 0, `sevchip c-${s}`))));
  fill($('#dropdowns'), MORE.map(([k, l]) => dropdown(k, l)),
    Object.entries(S.x).map(([k, v]) => h('button', { class: 'chip on', title: 'Remove this filter', onclick: () => { delete S.x[k]; changed(); } },
      `${EXACT[k]}: `, /^0x/.test(v) ? h('code', {}, short(v)) : v, ' ×')));
  $('#clear').hidden = !(Object.keys(S.f).length || Object.keys(S.x).length || S.q || S.min);
}

function drawList({ total: t, rows }) {
  total = t;
  pageIds = rows.map(r => r.id);
  const allOnPage = pageIds.length && pageIds.every(id => picked.has(id));
  const pageBox = h('input', { type: 'checkbox', checked: allOnPage, title: 'Select this page', 'aria-label': 'Select this page',
    onchange: e => { pageIds.forEach(id => e.target.checked ? picked.add(id) : picked.delete(id)); drawList({ total, rows }); } });
  const head = h('thead', {}, h('tr', {}, h('th', { class: 'chk' }, pageBox), COLUMNS.map(([key, label, cls]) =>
    h('th', { class: `${cls || ''} sortable${S.sort === key ? ' sorted ' + S.dir : ''}`, onclick: () => sortBy(key) }, label))));
  const body = h('tbody', {}, rows.length ? rows.map(row)
    : h('tr', {}, h('td', { class: 'empty', colspan: COLUMNS.length + 1 }, 'No finding matches these filters.')));
  $('#grid').replaceChildren(head, body);
  $('#listhead').replaceChildren(h('b', {}, `${num(total)} finding${total === 1 ? '' : 's'}`), 'sorted by',
    h('select', { onchange: e => sortBy(e.target.value), 'aria-label': 'Sort by' },
      Object.entries(SORTS).map(([k, label]) => h('option', { value: k, selected: k === S.sort }, label))),
    h('button', { title: 'Reverse the order', onclick: () => { S.dir = S.dir === 'asc' ? 'desc' : 'asc'; S.page = 0; refresh(); } },
      S.dir === 'asc' ? '▲' : '▼'));
  drawPager();
  drawBulk();
}

function team(r) {
  if (r.project) return h('b', { title: 'Project' }, r.project);
  if (r.label) return h('span', { class: 'tag', title: 'Explorer tag: a lead, not a verified name' }, r.label);
  if (r.name) return h('span', { title: 'Contract name' }, r.name);
  return h('code', { title: r.address }, short(r.address));
}

function row(r) {
  const cur = { status: r.status, assignee: r.assignee || '' };
  const stop = e => e.stopPropagation();
  return h('tr', { class: 'r' + (S.open === r.id ? ' open' : ''), onclick: () => openFinding(r.id) },
    h('td', { class: 'chk', onclick: stop }, h('input', { type: 'checkbox', checked: picked.has(r.id), 'aria-label': 'Select',
      onchange: e => { e.target.checked ? picked.add(r.id) : picked.delete(r.id); drawBulk(); } })),
    h('td', {}, sevPill(r.severity)),
    h('td', { class: 'fin', title: r.justification || '' }, h('div', { class: 't' }, r.title),
      h('div', { class: 'sub' }, team(r), r.category_name ? ` · ${r.category_name}` : '', r.level !== 'confirmed' ? ` · ${r.level}` : '',
        r.copies > 1 ? ` · ${num(r.copies)} copies` : '',
        (r.gaps || '').includes('team-unknown') ? h('span', { class: 'warnc', title: META.gaps['team-unknown'] }, ' · team unknown') : '')),
    h('td', { class: 'n', title: valueTip(r) }, money(r.held_now ?? r.value_usd)),
    h('td', { class: 'ctl', onclick: stop }, statusSelect(r.status, s => save([r.id], { status: s }, cur))),
    h('td', { class: 'ctl', onclick: stop }, assigneeSelect(cur.assignee, a => save([r.id], { assignee: a }, cur))),
    h('td', { class: 'cm' }, r.comments
      ? [h('span', { class: 'badge', title: `${r.comments} comment${r.comments > 1 ? 's' : ''}` }, num(r.comments)),
        h('span', { class: 'snip', title: `${r.last_comment_by}, ${when(r.last_comment_at)}\n\n${r.last_comment}` },
          h('b', {}, r.last_comment_by), ': ', r.last_comment)]
      : h('span', { class: 'soft' }, '—')),
    h('td', { class: 'upd', title: r.updated_at ? `${r.updated_by}, ${when(r.updated_at)}` : '' },
      r.updated_at ? [ago(r.updated_at), h('div', { class: 'sub' }, r.updated_by)] : h('span', { class: 'soft' }, '—')));
}

function statusSelect(value, onchange) {
  const s = h('select', { class: `st s-${value}`, 'aria-label': 'Outreach status', title: META.status_help[value],
    onchange: () => onchange(s.value) }, META.statuses.map(st => h('option', { value: st, selected: st === value }, st)));
  return s;
}
function assigneeSelect(value, onchange) {
  const names = META.users.includes(value) || !value ? META.users : [...META.users, value];  // an old assignee without an account
  return h('select', { class: 'as' + (value ? '' : ' none'), 'aria-label': 'Assignee', onchange: e => onchange(e.target.value) },
    h('option', { value: '', selected: !value }, 'nobody'),
    names.map(u => h('option', { value: u, selected: u === value }, u === META.user ? `${u} (me)` : u)));
}

function sortBy(key) {
  S.dir = S.sort === key ? (S.dir === 'asc' ? 'desc' : 'asc') : (['severity', 'title', 'status', 'assignee'].includes(key) ? 'asc' : 'desc');
  S.sort = key; S.page = 0;
  refresh();
}

function drawPager() {
  const pages = Math.max(1, Math.ceil(total / S.size));
  const from = total ? S.page * S.size + 1 : 0, to = Math.min(total, (S.page + 1) * S.size);
  $('#pager').replaceChildren(
    h('span', {}, `${num(from)}–${num(to)} of ${num(total)}`),
    h('button', { disabled: S.page === 0, onclick: () => { S.page--; refresh(); } }, '‹ Prev'),
    h('span', {}, `page ${num(S.page + 1)} of ${num(pages)}`),
    h('button', { disabled: S.page >= pages - 1, onclick: () => { S.page++; refresh(); } }, 'Next ›'),
    h('select', { 'aria-label': 'Findings per page', onchange: e => { S.size = +e.target.value; S.page = 0; refresh(); } },
      [50, 100, 200].map(n => h('option', { value: String(n), selected: n === S.size }, `${n} per page`))));
}

function drawBulk() {
  const n = picked.size, bar = $('#bulk');
  bar.hidden = !n;
  if (!n) return;
  const st = h('select', { 'aria-label': 'Status' }, h('option', { value: '' }, 'status: keep'), META.statuses.map(s => h('option', { value: s }, s)));
  const as = h('select', { 'aria-label': 'Assignee' }, h('option', { value: '*' }, 'assignee: keep'), h('option', { value: '' }, 'nobody'),
    META.users.map(u => h('option', { value: u }, u === META.user ? `${u} (me)` : u)));
  const cm = h('input', { type: 'text', placeholder: 'comment on each (optional)', maxlength: '5000', 'aria-label': 'Comment' });
  fill(bar,
    h('b', {}, `${num(n)} selected`),
    n < total ? h('button', { class: 'link', onclick: selectAll }, `select all ${num(total)} matching`) : null,
    st, as, cm,
    h('button', { class: 'primary', onclick: async () => {
      const change = {};
      if (st.value) change.status = st.value;
      if (as.value !== '*') change.assignee = as.value;
      if (cm.value.trim()) change.comment = cm.value.trim();
      if (!Object.keys(change).length) return toast('Pick a status or an assignee, or write a comment', true);
      if (n > 25 && !confirm(`Change ${num(n)} findings?`)) return;
      const ids = [...picked];
      picked.clear();
      await save(ids, change);
    } }, 'Apply'),
    h('button', { class: 'link', onclick: () => { picked.clear(); refresh(); } }, 'cancel'));
}

async function selectAll() {
  try {
    (await api('/api/ids?' + params())).forEach(id => picked.add(id));
    refresh();
  } catch (e) { toast(e.message, true); }
}

// One save path for the list, the finding and the bulk bar. `expect` is what the page showed of one finding: the
// server refuses the change if someone changed it since, and the page then shows what is there now.
async function save(ids, change, expect) {
  let ok = false;
  try {
    const r = await api('/api/outreach', { ids, ...change, ...(expect ? { expect } : {}) });
    toast(!r.changed ? 'Nothing changed' : ids.length > 1 ? `Saved: ${num(r.changed)} findings changed` : 'Saved');
    ok = true;
  } catch (e) { toast(e.message, true); }
  statsKey = null;
  await refresh();
  if (S.open) await openFinding(S.open, true);
  return ok;
}

// ---------- one finding ----------
async function openFinding(id, keepScroll) {
  S.open = id;
  writeHash();
  document.querySelectorAll('#grid tr.r').forEach((tr, k) => tr.classList.toggle('open', pageIds[k] === id));
  let d;
  try { d = await api('/api/finding/' + encodeURIComponent(id)); } catch (e) { toast(e.message, true); return closeFinding(); }
  if (S.open !== id) return;
  const dr = $('#drawer'), top = keepScroll ? dr.scrollTop : 0;
  const o = d.outreach, cur = { status: o.status, assignee: o.assignee || '' };
  const k = pageIds.indexOf(id);
  const composer = h('textarea', { rows: 3, maxlength: '5000', 'aria-label': 'Comment',
    placeholder: 'Who you contacted, how, what they said… (⌘/Ctrl + Enter posts)' });
  const post = async () => {
    const text = composer.value.trim();
    if (!text) return composer.focus();
    if (!await save([d.id], { comment: text })) {
      const again = $('#drawer textarea');  // the drawer was drawn again: keep what was typed
      if (again) again.value = text;
    }
  };
  composer.addEventListener('keydown', e => { if (e.key === 'Enter' && (e.metaKey || e.ctrlKey)) post(); });
  const gaps = (d.gaps || '').split(' ').filter(Boolean);
  fill(dr,
    h('div', { class: 'dr-head' },
      h('button', { class: 'nav', title: 'Previous finding (k)', 'aria-label': 'Previous finding', disabled: k <= 0 && S.page === 0, onclick: () => step(-1) }, '‹'),
      h('button', { class: 'nav', title: 'Next finding (j)', 'aria-label': 'Next finding', disabled: k === pageIds.length - 1 && (S.page + 1) * S.size >= total, onclick: () => step(1) }, '›'),
      sevPill(d.severity), h('span', { class: 'soft' }, d.level), h('code', { class: 'fid' }, d.id), copyBtn(d.id),
      h('span', { class: 'links' }, link(`${META.repo_url}/blob/${META.commit}/findings/${d.id}.md`, 'GitHub ↗'),
        link(`https://etherscan.io/address/${d.address}`, 'Etherscan ↗')),
      h('button', { class: 'x', title: 'Close (Esc)', 'aria-label': 'Close', onclick: closeFinding }, '×')),
    h('h2', {}, d.title),
    h('section', { class: 'card outreach', 'aria-label': 'Outreach' },
      h('div', { class: 'orow' }, h('span', { class: 'fl' }, 'Status'),
        h('div', { class: 'pills', role: 'group', 'aria-label': 'Outreach status' }, META.statuses.map(s =>
          h('button', { class: `stbtn s-${s}${s === o.status ? ' on' : ''}`, title: META.status_help[s], 'aria-pressed': String(s === o.status),
            onclick: () => s !== o.status && save([d.id], { status: s }, cur) }, h('i', { class: 'dot' }), s)))),
      h('p', { class: 'help' }, META.status_help[o.status]),
      h('div', { class: 'orow' }, h('span', { class: 'fl' }, 'Assignee'),
        assigneeSelect(cur.assignee, a => save([d.id], { assignee: a }, cur)),
        cur.assignee !== META.user ? h('button', { class: 'btn', onclick: () => save([d.id], { assignee: META.user }, cur) }, 'Assign to me') : null,
        o.updated_at ? h('span', { class: 'soft', title: when(o.updated_at) }, `last change ${ago(o.updated_at)} by ${o.updated_by}`) : null),
      h('div', { class: 'thread' }, d.log.length ? d.log.map(entry) : h('p', { class: 'soft' }, 'No comments or changes yet.')),
      h('div', { class: 'composer' }, composer,
        h('div', { class: 'actions' }, h('button', { class: 'primary', onclick: post }, 'Post comment'), h('span', { class: 'soft' }, '⌘/Ctrl + Enter')))),
    gaps.length ? h('div', { class: 'warn' }, h('b', {}, 'Missing in the registry: '),
      gaps.map(g => META.gaps[g] || g).join('; '), d.problems ? h('pre', {}, d.problems) : '') : '',
    h('h3', {}, 'Who to contact'), contactView(d),
    cardView(d),
    d.sources.length || d.reviews.length ? h('details', { class: 'people' },
      h('summary', {}, `Sources and reviews (${d.sources.length + d.reviews.length})`),
      h('ul', {}, d.sources.map(s => person(s, true)), d.reviews.map(s => person(s, false)))) : '');
  dr.hidden = false;
  $('#scrim').hidden = false;
  dr.scrollTop = top;
}

// The thread: comments, and the status and assignee changes between them.
function entry(e) {
  if (e.field === 'comment') {
    return h('div', { class: 'cmt' }, h('div', { class: 'by' }, h('b', {}, e.who), h('span', { class: 'soft', title: when(e.at) }, ago(e.at))),
      h('div', { class: 'body' }, linkify(e.new)));
  }
  const what = e.field === 'status' ? ['set the status to ', statusPill(e.new)]
    : e.new ? ['assigned it to ', h('b', {}, e.new)] : ['unassigned ', h('b', {}, e.old)];
  return h('div', { class: 'evt' }, h('b', {}, e.who), ' ', what, h('span', { class: 'soft', title: when(e.at) }, ` · ${ago(e.at)}`));
}

function person(s, source) {
  return h('li', {}, h('b', {}, s.who || '?'), ` · ${s.date || ''} · ${source ? s.study + ' · ' : 'review · '}${s.verdict || ''}`,
    s.rating ? [' · ', sevPill(s.rating)] : '', s.note ? h('div', { class: 'sub' }, s.note) : '',
    s.ref ? h('div', { class: 'sub' }, /^https?:\/\//.test(s.ref) ? link(s.ref, s.ref.replace(/^https:\/\/github\.com\//, '')) : s.ref) : '');
}

async function step(delta) {
  const k = pageIds.indexOf(S.open) + delta;
  if (k >= 0 && k < pageIds.length) return openFinding(pageIds[k]);
  if (delta > 0 && (S.page + 1) * S.size < total) S.page++;
  else if (delta < 0 && S.page > 0) S.page--;
  else return;
  await refresh();
  if (pageIds.length) openFinding(delta > 0 ? pageIds[0] : pageIds[pageIds.length - 1]);
}

const none = () => h('span', { class: 'soft' }, 'not established');
const shown = x => x == null || x === '' || (Array.isArray(x) && !x.length) ? none() : x;
const facts = rows => h('dl', { class: 'facts' }, rows.map(([k, x]) => [h('dt', {}, k), h('dd', {}, shown(x))]));

// Leads for reaching the team, and the other findings that share its project or its deployer.
function contactView(d) {
  const same = Object.entries(d.same || {}).filter(([, n]) => n > 1).map(([k, n]) =>
    h('button', { class: 'link', onclick: () => { S.f = {}; S.x = { [k]: d[k] }; S.q = ''; S.min = ''; $('#q').value = ''; $('#min').value = ''; closeFinding(); changed(); } },
      `All ${num(n)} findings of this ${k}`));
  return h('div', { class: 'card' },
    facts([
      ['Team', d.project ? h('b', {}, d.project) : d.label ? h('span', { class: 'tag', title: 'Explorer tag: a lead, not a verified name' }, d.label) : d.name],
      ['Contract', [d.name ? [h('b', {}, d.name), ' '] : '', etherscan(d.address), copyBtn(d.address)]],
      ['Deployer', d.deployer ? [etherscan(d.deployer), copyBtn(d.deployer), d.factory ? [' via ', etherscan(d.factory)] : ''] : null]]),
    same.length ? h('p', { class: 'same' }, same) : '');
}

// A finding as its readers see it (AGENTS.md): the card, with "not established" for an empty field, then
// what the board adds. The server sends neither the Reviewer notes nor the fields marked "not shown".
const WHOSE = { users: "users' money", operator: "the operator's money", mixed: "users' and the operator's money" };
function cardView(d) {
  const code = !d.code ? null : d.code === 'decompiled' && d.code_url ? link(`${META.repo_url}/blob/${META.commit}/${d.code_url}`, 'decompiled')
    : /^https?:\/\//.test(d.code_url || '') ? link(d.code_url, d.code) : d.code;
  const holds = d.value_usd == null ? null : [money(d.value_usd), d.value_whose ? `, ${WHOSE[d.value_whose] || d.value_whose}` : '',
    d.value_basis && d.value_basis !== 'held' ? ` (${d.value_basis})` : '', d.as_of ? `, on ${d.as_of}` : ''].join('');
  const held = d.held_now == null ? null : [
    h('div', {}, h('b', {}, money(d.held_now)), ` on ${d.held_at}, in ETH and every priced token, at this address`),
    d.holdings ? h('div', { class: 'sub' }, holdingsText(d.holdings, 5)) : '',
    d.family_held != null ? h('div', {}, 'Same code: ', h('b', {}, money(d.family_held)), ` over ${num(d.family_addresses)} addresses`) : ''];
  return [
    h('h3', {}, 'Card'),
    h('div', { class: 'card fcard' },
      h('p', { class: 'just' }, sevPill(d.severity), ' ', shown(d.justification)),
      h('p', { class: 'cat' }, d.category_name ? `“${d.category_name}”` : none(), d.pattern_words ? h('span', { class: 'soft' }, ` · ${d.pattern_words}`) : ''),
      h('h4', {}, 'What happens'), d.what_happens ? h('div', { class: 'md', html: md(d.what_happens) }) : h('p', {}, none()),
      h('h4', {}, 'What its team can do'), h('p', { class: 'action' }, shown(d.action)),
      h('h4', {}, 'Evidence'), d.evidence ? h('div', { class: 'md', html: md(d.evidence) }) : h('p', {}, none()),
      facts([
        ['Contract', [d.name ? [h('b', {}, d.name), ' '] : '', etherscan(d.address)]],
        ['Project', d.project], ['Explorer tag', d.label], ['Code', code],
        ...d.proxy_of ? [['Proxy of', etherscan(d.proxy_of)]] : [],  // set only "when the address is a proxy"
        ['Copies', d.copies != null ? num(d.copies) : null],
        ['Upgradeable', d.upgradeable == null ? null : d.upgradeable === 'no' ? 'no' : 'yes'],  // the card shows only yes or no
        ['Holds', holds], ['Activity', d.txs_90d != null ? `${num(d.txs_90d)} transactions in the 90 days to ${d.as_of}` : null],
        ['Impact', d.impact], ['Evidence level', d.evidence_level]])),
    h('h3', {}, 'On the board'),
    h('dl', { class: 'facts' }, [['Held now', held], ['Found by', META.studies[d.study] || d.study],
      ['Also checked by', (d.studies || '').split(' ').filter(s => s && s !== d.study).map(s => META.studies[s] || s).join(', ')],
      ['Reported', d.reported],
      ['Related', d.related ? d.related.split(' ').map(r => [h('a', { href: '#', onclick: e => { e.preventDefault(); openFinding(r); } }, r), ' ']) : null],
      ['Duplicate of', d.duplicate_of]].filter(([, x]) => x != null && x !== '').map(([k, x]) => [h('dt', {}, k), h('dd', {}, x)]))];
}

function closeFinding() {
  S.open = '';
  writeHash();
  $('#drawer').hidden = true;
  $('#scrim').hidden = true;
  document.querySelectorAll('#grid tr.r.open').forEach(tr => tr.classList.remove('open'));
}

// ---------- start ----------
async function start() {
  try { META = await api('/api/meta'); } catch (e) { return toast(e.message, true); }
  $('#meta').replaceChildren('signed in as ', h('b', {}, META.user));
  readHash();
  let timer;
  $('#q').addEventListener('input', e => { clearTimeout(timer); timer = setTimeout(() => { S.q = e.target.value.trim(); changed(); }, 300); });
  $('#min').addEventListener('change', e => { S.min = e.target.value; changed(); });
  $('#clear').addEventListener('click', clearAll);
  $('#scrim').addEventListener('click', closeFinding);
  document.addEventListener('click', e => {
    if (!e.target.closest('details.dd')) { document.querySelectorAll('details.dd[open]').forEach(d => { d.open = false; }); openDD = ''; }
  });
  document.addEventListener('keydown', e => {
    const typing = /INPUT|TEXTAREA|SELECT/.test(document.activeElement.tagName);
    if (e.key === 'Escape') { if (S.open) closeFinding(); else document.querySelectorAll('details.dd[open]').forEach(d => { d.open = false; }); }
    else if (typing || e.metaKey || e.ctrlKey || e.altKey) return;
    else if (e.key === '/') { e.preventDefault(); $('#q').focus(); }
    else if (S.open && (e.key === 'j' || e.key === 'k')) step(e.key === 'j' ? 1 : -1);
  });
  window.addEventListener('hashchange', () => { readHash(); statsKey = null; refresh(); S.open ? openFinding(S.open) : closeFinding(); });
  // Others work on the board too: coming back to the tab shows their changes.
  document.addEventListener('visibilitychange', () => {
    if (document.hidden) return;
    statsKey = null;
    refresh();
    if (S.open && !document.querySelector('#drawer textarea')?.value) openFinding(S.open, true);
  });
  await refresh();
  if (S.open) openFinding(S.open);
}
start();
