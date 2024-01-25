package internal

type Seeds struct {
	seeds []Seed
}

func (s *Seeds) AddSeed(seed Seed) {
	s.seeds = append(s.seeds, seed)
}

func (s *Seeds) AddSeedValue(value int) {
	var seed Seed
	seed.id = value

	s.AddSeed(seed)
}
