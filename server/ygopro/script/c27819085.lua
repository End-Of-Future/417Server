--圣光飞龙-进化
function c27819085.initial_effect(c)
	 --Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit() 
	--lv 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,17819085)  
	e1:SetTarget(c27819085.lvtg) 
	e1:SetOperation(c27819085.lvop) 
	c:RegisterEffect(e1) 
	--synchro effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27819085,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,27819085)
	e2:SetCondition(c27819085.sccon)
	e2:SetTarget(c27819085.sctarg)
	e2:SetOperation(c27819085.scop)
	c:RegisterEffect(e2)
end 
c27819085.SetCard_XXLight=true 
c27819085.SetCard_XXLightDragon=true 
function c27819085.lvfil(c,e,tp) 
	return c:IsFaceup() and c.SetCard_XXLight and Duel.IsExistingMatchingCard(c27819085.tgfil,tp,LOCATION_DECK,0,1,nil,c)   
end   
function c27819085.tgfil(c,sc) 
	local lv=sc:GetLevel()
	return c:IsAbleToGrave() and c.SetCard_XXLight and c:IsLevelAbove(1)  
end 
function c27819085.lvtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c27819085.lvfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end 
	Duel.SelectTarget(tp,c27819085.lvfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
end 
function c27819085.lvop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	local g=Duel.GetMatchingGroup(c27819085.tgfil,tp,LOCATION_DECK,0,nil,tc) 
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and g:GetCount()>0 then  
	local sc=g:Select(tp,1,1,nil):GetFirst() 
	Duel.SendtoGrave(sc,REASON_EFFECT) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_LEVEL) 
	e1:SetRange(LOCATION_MZONE)  
	e1:SetValue(sc:GetLevel()) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
	tc:RegisterEffect(e1) 
	end 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c27819085.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c27819085.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_SYNCHRO) 
end 
function c27819085.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c27819085.sctarg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,c) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c27819085.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c)
	end
end












