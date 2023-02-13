--王牌竞赛 孤狼
function c88880534.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c88880534.lcheck)
	c:EnableReviveLimit() 
	--SpecialSummon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,88880534)
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e1:SetTarget(c88880534.sptg) 
	e1:SetOperation(c88880534.spop) 
	c:RegisterEffect(e1)  
	--link summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88880534,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,18880534)
	e2:SetCondition(c88880534.lkcon)
	e2:SetTarget(c88880534.lktg)
	e2:SetOperation(c88880534.lkop)
	c:RegisterEffect(e2)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c88880534.damcon1)
	e2:SetOperation(c88880534.damop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c88880534.regcon)
	e3:SetOperation(c88880534.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c88880534.damcon2)
	e4:SetOperation(c88880534.damop2)
	c:RegisterEffect(e4)
	if not c88880534.global_check then
		c88880534.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetOperation(c88880534.count)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(c88880534.reset)
		Duel.RegisterEffect(ge2,0)
	end
end
function c88880534.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xd88) 
end
function c88880534.spfilter(c,e,tp,lkc)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and c:IsReason(REASON_LINK) and c:IsReason(REASON_MATERIAL) and c:GetReasonCard()==lkc
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88880534.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	local ct=mg:GetCount()
	if chk==0 then return c:IsSummonType(SUMMON_TYPE_LINK)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
		and mg:FilterCount(c88880534.spfilter,nil,e,tp,c)==ct end
	Duel.SetTargetCard(mg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,mg,ct,0,0)
end
function c88880534.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local mg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=mg:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()<mg:GetCount() then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<g:GetCount() then return end
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		tc:RegisterEffect(e1,true)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c88880534.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c88880534.lktg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0xd88)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c88880534.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0xd88) 
	local g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
	end
end
function c88880534.count(e,tp,eg,ep,ev,re,r,rp)
	c88880534.chain_solving=true
end
function c88880534.reset(e,tp,eg,ep,ev,re,r,rp)
	c88880534.chain_solving=false
end
function c88880534.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp) and not c88880534.chain_solving and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c88880534.damop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,88880534)
	local ct=eg:FilterCount(Card.IsControler,nil,1-tp)
	Duel.Damage(1-tp,ct*400,REASON_EFFECT)
end
function c88880534.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp) and c88880534.chain_solving and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c88880534.regop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(Card.IsControler,nil,1-tp)
	e:GetHandler():RegisterFlagEffect(35199657,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,ct)
end
function c88880534.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(35199657)>0 and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c88880534.damop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,88880534)
	local labels={e:GetHandler():GetFlagEffectLabel(35199657)}
	local ct=0
	for i=1,#labels do ct=ct+labels[i] end
	e:GetHandler():ResetFlagEffect(35199657)
	Duel.Damage(1-tp,ct*400,REASON_EFFECT)
end







