--无敌巨龙 迦拉克隆
function c88888850.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,88888850+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c88888850.accon)  
	e1:SetTarget(c88888850.actg) 
	e1:SetOperation(c88888850.acop) 
	c:RegisterEffect(e1) 
	--atk 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetRange(LOCATION_FZONE) 
	e2:SetCountLimit(1) 
	e2:SetTarget(c88888850.atktg) 
	e2:SetOperation(c88888850.atkop) 
	c:RegisterEffect(e2)  
	c88888850.field_effect=e2 
	--to hand 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_LEAVE_FIELD)  
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetTarget(c88888850.thtg) 
	e3:SetOperation(c88888850.thop) 
	c:RegisterEffect(e3) 
	--to hand 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_TOHAND) 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e4:SetCode(EVENT_SUMMON_SUCCESS) 
	e4:SetProperty(EFFECT_FLAG_DELAY) 
	e4:SetRange(LOCATION_GRAVE) 
	e4:SetCountLimit(1,18888850+EFFECT_COUNT_CODE_DUEL) 
	e4:SetTarget(c88888850.xthtg) 
	e4:SetOperation(c88888850.xthop) 
	c:RegisterEffect(e4) 
	local e5=e4:Clone() 
	e5:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e5) 
	local e6=e4:Clone() 
	e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS) 
	c:RegisterEffect(e6)  
end 
c88888850.SetCard_A_jlcl=true 
function c88888850.ackfil(c) 
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) 
end 
function c88888850.accon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c88888850.ackfil,tp,LOCATION_MZONE,0,1,nil) 
end  
function c88888850.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_DECK,0,1,nil) end  
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(88888850,5))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(88888850,5))
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,1,tp,LOCATION_HAND)
end 
function c88888850.acop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g1=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil,REASON_EFFECT) 
	local hg=g1:Select(tp,1,1,nil) 
	if Duel.SendtoGrave(hg,REASON_EFFECT+REASON_DISCARD)~=0 then 
	local g=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_DECK,0,nil,RACE_DRAGON) 
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dcount==0 then return end
	if g:GetCount()==0 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	local seq=-1
	local tc=g:GetFirst()
	local spcard=nil
	while tc do
		if tc:GetSequence()>seq then
			seq=tc:GetSequence()
			spcard=tc
		end
		tc=g:GetNext()
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
		if spcard:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(spcard,nil,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,spcard) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2000) 
		e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		spcard:RegisterEffect(e1) 
		local e2=e1:Clone() 
		e2:SetCode(EFFECT_UPDATE_DEFENSE) 
		spcard:RegisterEffect(e2)  
		Duel.ShuffleHand(tp)
		end 
	if Duel.GetFlagEffect(tp,88888850)~=0 and Duel.SelectYesNo(tp,aux.Stringid(88888850,0)) then 
	local g=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_DECK,0,nil,RACE_DRAGON) 
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dcount==0 then return end
	if g:GetCount()==0 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.ShuffleDeck(tp)
		return
	end
	local seq=-1
	local tc=g:GetFirst()
	local spcard=nil
	while tc do
		if tc:GetSequence()>seq then
			seq=tc:GetSequence()
			spcard=tc
		end
		tc=g:GetNext()
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
		if spcard:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(spcard,nil,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,spcard) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
		e1:SetValue(2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		spcard:RegisterEffect(e1) 
		local e2=e1:Clone() 
		e2:SetCode(EFFECT_UPDATE_DEFENSE) 
		spcard:RegisterEffect(e2)  
		Duel.ShuffleHand(tp)
		end 
	end 
	end 
end  
function c88888850.atkfil(c) 
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) 
end 
function c88888850.atktg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.IsExistingMatchingCard(c88888850.atkfil,tp,LOCATION_MZONE,0,1,nil) end 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(88888850,6))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(88888850,6))
end 
function c88888850.atkop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c88888850.atkfil,tp,LOCATION_MZONE,0,nil) 
	if g:GetCount()>0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst()  
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)  
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
	tc:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(2000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
	tc:RegisterEffect(e1) 
	end 
	Duel.RegisterFlagEffect(tp,88888850,RESET_PHASE+PHASE_END,0,1)  
end 
function c88888850.thfil(c) 
	return c:IsRace(RACE_DRAGON) and c:IsAbleToHand()  
end 
function c88888850.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return bit.band(e:GetHandler():GetPreviousPosition(),POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c88888850.thfil,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(88888850,7))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(88888850,7))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA) 
end  
function c88888850.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c88888850.thfil,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,nil) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SendtoHand(sg,nil,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg) 
	end 
end
function c88888850.xthtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToHand() end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0) 
end  
function c88888850.xthop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
	Duel.SendtoHand(c,nil,REASON_EFFECT) 
	end 
end 





