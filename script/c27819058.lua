--五王的降临
function c27819058.initial_effect(c) 
	c:SetUniqueOnField(1,0,27819058)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetTarget(c27819058.actg) 
	e1:SetOperation(c27819058.acop)
	c:RegisterEffect(e1)
	-- 
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_FIELD)
	--e2:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	--e2:SetRange(LOCATION_SZONE)
	--e2:SetTargetRange(LOCATION_MZONE,0)
	--e2:SetTarget(c27819058.tg)
	--c:RegisterEffect(e2)
	-- 
	--local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(27819058,0))
	--e3:SetCategory(CATEGORY_DRAW)
	--e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	--e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e3:SetProperty(EFFECT_FLAG_DELAY)
	--e3:SetRange(LOCATION_SZONE)
	--e3:SetCountLimit(1,27819058+1500)
	--e3:SetCondition(c27819058.spcon1)
	--e3:SetTarget(c27819058.sptg1)
	--e3:SetOperation(c27819058.spop1)
	--c:RegisterEffect(e3)
	-- 
	--local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(27819058,1))
	--e3:SetCategory(CATEGORY_DRAW)
	--e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	--e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e3:SetProperty(EFFECT_FLAG_DELAY)
	--e3:SetRange(LOCATION_SZONE)
	--e3:SetCountLimit(1,27819058+3000)
	--e3:SetCondition(c27819058.spcon1)
	--e3:SetTarget(c27819058.sptg2)
	---e3:SetOperation(c27819058.spop2)
	--c:RegisterEffect(e3)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27819058,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCountLimit(2) 
	e2:SetCondition(c27819058.condition) 
	e2:SetTarget(c27819058.target)
	e2:SetOperation(c27819058.operation)
	c:RegisterEffect(e2)
end
c27819058.SetCard_fiveking=true
function c27819058.tg(e,c)
	return c.SetCard_fiveking and c:IsType(TYPE_MONSTER)
end
function c27819058.chainlm(e,ep,tp)
	return not e:GetHandler():IsCode(27819058)
end
function c27819058.descfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_XYZ) and c.SetCard_fiveking and c:IsSummonPlayer(tp)
end
function c27819058.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c27819058.descfilter,1,nil)
end
function c27819058.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetChainLimit(c27819058.chainlm)
end
function c27819058.spop1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c27819058.tdfilter(c)
	return c.SetCard_fiveking
end
function c27819058.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27819058.tdfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
		Duel.SetChainLimit(c27819058.chainlm)
end
function c27819058.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(27819058,3))
	local g=Duel.SelectMatchingCard(tp,c27819058.tdfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,SEQ_DECKTOP)
		Duel.ConfirmDecktop(tp,1)
	end
end 
function c27819058.thfil(c) 
	return c:IsAbleToHand() and c.SetCard_fiveking and c:IsType(TYPE_MONSTER)
end 
function c27819058.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c27819058.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end 
function c27819058.acop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c27819058.thfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
		if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) then  
		Duel.BreakEffect()
		local sg=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil,REASON_EFFECT) 
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD) 
		end 
	end 
end 
function c27819058.ckfil(c,tp)
	return c.SetCard_fiveking and c:IsType(TYPE_XYZ) and c:IsSummonPlayer(tp) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c27819058.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c27819058.ckfil,1,nil,tp)
end 
function c27819058.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c27819058.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end









