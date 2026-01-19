-- Local Blocks Seed Data
-- These blocks are stored locally, no remote fetch required
-- Run with: xplat task db:seed

-- Hero Section Block
INSERT INTO tbl_blocks (id, title, slug_name, channel_slugname, block_description, block_content, block_css, icon_image, cover_image, prime, is_active, tenant_id, created_on, created_by, is_deleted)
VALUES (
    1,
    'Hero Section',
    'hero-section',
    'blog',
    'A full-width hero section with title, subtitle and CTA button',
    '<section class="hero-section">
      <div class="hero-content">
        <h1 class="hero-title">{{.Title}}</h1>
        <p class="hero-subtitle">{{.Subtitle}}</p>
        <a href="{{.CTALink}}" class="hero-cta">{{.CTAText}}</a>
      </div>
    </section>',
    '.hero-section {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      padding: 80px 20px;
      text-align: center;
      color: white;
    }
    .hero-title { font-size: 3rem; margin-bottom: 1rem; }
    .hero-subtitle { font-size: 1.25rem; opacity: 0.9; margin-bottom: 2rem; }
    .hero-cta {
      background: white;
      color: #667eea;
      padding: 12px 32px;
      border-radius: 8px;
      text-decoration: none;
      font-weight: 600;
    }',
    '/public/img/blocks/hero.svg',
    '/public/img/blocks/hero-cover.png',
    1,
    1,
    '1',
    NOW(),
    1,
    0
) ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    block_content = EXCLUDED.block_content,
    block_css = EXCLUDED.block_css;

-- Card Grid Block
INSERT INTO tbl_blocks (id, title, slug_name, channel_slugname, block_description, block_content, block_css, icon_image, cover_image, prime, is_active, tenant_id, created_on, created_by, is_deleted)
VALUES (
    2,
    'Card Grid',
    'card-grid',
    'blog',
    'A responsive grid of content cards',
    '<section class="card-grid">
      {{range .Cards}}
      <div class="card">
        <img src="{{.Image}}" alt="{{.Title}}" class="card-image">
        <div class="card-body">
          <h3 class="card-title">{{.Title}}</h3>
          <p class="card-text">{{.Description}}</p>
          <a href="{{.Link}}" class="card-link">Read More →</a>
        </div>
      </div>
      {{end}}
    </section>',
    '.card-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
      gap: 24px;
      padding: 40px 20px;
    }
    .card {
      background: white;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      overflow: hidden;
    }
    .card-image { width: 100%; height: 200px; object-fit: cover; }
    .card-body { padding: 20px; }
    .card-title { margin: 0 0 12px; font-size: 1.25rem; }
    .card-text { color: #666; margin-bottom: 16px; }
    .card-link { color: #667eea; text-decoration: none; font-weight: 500; }',
    '/public/img/blocks/cards.svg',
    '/public/img/blocks/cards-cover.png',
    0,
    1,
    '1',
    NOW(),
    1,
    0
) ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    block_content = EXCLUDED.block_content,
    block_css = EXCLUDED.block_css;

-- Text Block
INSERT INTO tbl_blocks (id, title, slug_name, channel_slugname, block_description, block_content, block_css, icon_image, cover_image, prime, is_active, tenant_id, created_on, created_by, is_deleted)
VALUES (
    3,
    'Rich Text',
    'rich-text',
    'blog',
    'A simple rich text content block',
    '<article class="rich-text">
      {{.Content}}
    </article>',
    '.rich-text {
      max-width: 720px;
      margin: 0 auto;
      padding: 40px 20px;
      font-size: 1.125rem;
      line-height: 1.8;
      color: #333;
    }
    .rich-text h2 { margin: 2rem 0 1rem; }
    .rich-text p { margin-bottom: 1.5rem; }
    .rich-text a { color: #667eea; }
    .rich-text img { max-width: 100%; border-radius: 8px; margin: 1.5rem 0; }',
    '/public/img/blocks/text.svg',
    '/public/img/blocks/text-cover.png',
    0,
    1,
    '1',
    NOW(),
    1,
    0
) ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    block_content = EXCLUDED.block_content,
    block_css = EXCLUDED.block_css;

-- CTA Banner Block
INSERT INTO tbl_blocks (id, title, slug_name, channel_slugname, block_description, block_content, block_css, icon_image, cover_image, prime, is_active, tenant_id, created_on, created_by, is_deleted)
VALUES (
    4,
    'CTA Banner',
    'cta-banner',
    'blog',
    'A call-to-action banner with background',
    '<section class="cta-banner">
      <h2 class="cta-title">{{.Title}}</h2>
      <p class="cta-text">{{.Description}}</p>
      <div class="cta-buttons">
        <a href="{{.PrimaryLink}}" class="btn-primary">{{.PrimaryText}}</a>
        <a href="{{.SecondaryLink}}" class="btn-secondary">{{.SecondaryText}}</a>
      </div>
    </section>',
    '.cta-banner {
      background: #1a1a2e;
      color: white;
      padding: 60px 20px;
      text-align: center;
    }
    .cta-title { font-size: 2rem; margin-bottom: 1rem; }
    .cta-text { opacity: 0.8; margin-bottom: 2rem; max-width: 600px; margin-left: auto; margin-right: auto; }
    .cta-buttons { display: flex; gap: 16px; justify-content: center; flex-wrap: wrap; }
    .btn-primary {
      background: #667eea;
      color: white;
      padding: 12px 28px;
      border-radius: 8px;
      text-decoration: none;
    }
    .btn-secondary {
      border: 2px solid white;
      color: white;
      padding: 10px 28px;
      border-radius: 8px;
      text-decoration: none;
    }',
    '/public/img/blocks/cta.svg',
    '/public/img/blocks/cta-cover.png',
    0,
    1,
    '1',
    NOW(),
    1,
    0
) ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    block_content = EXCLUDED.block_content,
    block_css = EXCLUDED.block_css;

-- Feature List Block
INSERT INTO tbl_blocks (id, title, slug_name, channel_slugname, block_description, block_content, block_css, icon_image, cover_image, prime, is_active, tenant_id, created_on, created_by, is_deleted)
VALUES (
    5,
    'Feature List',
    'feature-list',
    'blog',
    'A list of features with icons',
    '<section class="feature-list">
      <h2 class="feature-title">{{.Title}}</h2>
      <div class="features">
        {{range .Features}}
        <div class="feature">
          <div class="feature-icon">{{.Icon}}</div>
          <h3>{{.Title}}</h3>
          <p>{{.Description}}</p>
        </div>
        {{end}}
      </div>
    </section>',
    '.feature-list {
      padding: 60px 20px;
      text-align: center;
    }
    .feature-title { font-size: 2rem; margin-bottom: 3rem; }
    .features {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 32px;
      max-width: 1200px;
      margin: 0 auto;
    }
    .feature { padding: 24px; }
    .feature-icon {
      width: 64px;
      height: 64px;
      background: #f0f4ff;
      border-radius: 16px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin: 0 auto 16px;
      font-size: 24px;
    }
    .feature h3 { margin-bottom: 8px; }
    .feature p { color: #666; }',
    '/public/img/blocks/features.svg',
    '/public/img/blocks/features-cover.png',
    0,
    1,
    '1',
    NOW(),
    1,
    0
) ON CONFLICT (id) DO UPDATE SET
    title = EXCLUDED.title,
    block_content = EXCLUDED.block_content,
    block_css = EXCLUDED.block_css;

-- Add blocks to the admin user's collection
INSERT INTO tbl_block_collections (user_id, block_id, tenant_id, is_deleted)
SELECT 1, id, '1', 0 FROM tbl_blocks WHERE is_deleted = 0
ON CONFLICT DO NOTHING;
