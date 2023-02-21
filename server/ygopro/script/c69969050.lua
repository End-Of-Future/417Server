--精灵术的预占
local m=69969050
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Effect 2  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,m+m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.postg)
	e2:SetOperation(cm.posop)
	c:RegisterEffect(e2)
end
--Effect 1
function cm.sp(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
		or (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0)
end
function cm.spt(c,e,tp)
	return c:IsType(TYPE_MONSTER) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function cm.s(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.p(c)
	return c:IsType(TYPE_MONSTER) 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,6)
		and Duel.GetDecktopGroup(1-tp,6):FilterCount(cm.p,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,1,1-tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerCanDiscardDeck(1-tp,6) then
		Duel.ConfirmDecktop(1-tp,6)
		local g=Duel.GetDecktopGroup(1-tp,6)
		if g:FilterCount(cm.p,nil)>0 then
			if g:IsExists(cm.sp,1,nil,e,tp) then
				local xg=g:Filter(cm.s,nil)
				local cg=g:Filter(cm.spt,nil,e,tp)
				local b1=#xg>0
				local b2=#cg>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
				local off=1
				local ops={}
				local opval={}
				if b1 then
					ops[off]=aux.Stringid(m,0)
					opval[off-1]=1
					off=off+1
				end
				if b2 then
					ops[off]=aux.Stringid(m,1)
					opval[off-1]=2
					off=off+1
				end
				local op=Duel.SelectOption(tp,table.unpack(ops))
				if opval[op]==1 then
					Duel.DisableShuffleCheck()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local tcc=xg:Select(tp,1,1,nil):GetFirst()
					local attr=tcc:GetAttribute()
					if tcc and Duel.SendtoGrave(tcc,REASON_EFFECT)>0
						and Duel.IsExistingMatchingCard(cm.so,tp,LOCATION_DECK,0,1,nil,e,tp,attr)
						and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
						local xg1=Duel.GetMatchingGroup(cm.so1,tp,LOCATION_DECK,0,nil,attr)
						local xg2=Duel.GetMatchingGroup(cm.so2,tp,LOCATION_DECK,0,nil,e,tp,attr)
						local b3=#xg1>0
						local b4=#xg2>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
						if b4 and (not b3 
							or Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))==1) then
							Duel.BreakEffect()
							if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
							local xg4=xg2:Select(tp,1,1,nil)
							if xg4:GetCount()>0 
								and Duel.SpecialSummon(xg4,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
								Duel.ConfirmCards(1-tp,xg4)
							end
						else
							Duel.BreakEffect()
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
							local xg3=xg1:Select(tp,1,1,nil)
							if xg3:GetCount()>0 then
								Duel.SendtoHand(xg3,nil,REASON_EFFECT)
								Duel.ConfirmCards(1-tp,xg3)
							end  
						end
					end
				elseif opval[op]==2 then
					Duel.DisableShuffleCheck()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local ag=cg:FilterSelect(tp,cm.spt,1,1,nil,e,tp)
					local tc=ag:GetFirst()
					local attr=tc:GetAttribute()
					if Duel.SpecialSummonStep(tc,0,tp,1-tp,false,false,POS_FACEUP) then
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
					end
					if Duel.SpecialSummonComplete()>0 
						and Duel.IsExistingMatchingCard(cm.so,tp,LOCATION_DECK,0,1,nil,e,tp,attr)
						and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
						local xg1=Duel.GetMatchingGroup(cm.so1,tp,LOCATION_DECK,0,nil,attr)
						local xg2=Duel.GetMatchingGroup(cm.so2,tp,LOCATION_DECK,0,nil,e,tp,attr)
						local b3=#xg1>0
						local b4=#xg2>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
						if b4 and (not b3 
							or Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))==1) then
							Duel.BreakEffect()
							if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
							local xg4=xg2:Select(tp,1,1,nil)
							if xg4:GetCount()>0 
								and Duel.SpecialSummon(xg4,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
								Duel.ConfirmCards(1-tp,xg4)
							end
						else
							Duel.BreakEffect()
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
							local xg3=xg1:Select(tp,1,1,nil)
							if xg3:GetCount()>0 then
								Duel.SendtoHand(xg3,nil,REASON_EFFECT)
								Duel.ConfirmCards(1-tp,xg3)
							end  
						end
					end
				end
			else
				Duel.ShuffleDeck(1-tp)
			end
		else
			Duel.ShuffleDeck(1-tp)
		end
	end
end
function cm.so(c,e,tp,attr)
	return c:IsAttribute(attr) and c:IsDefense(1500) and c:IsRace(RACE_SPELLCASTER)
		and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))
end
function cm.so1(c,attr)
	return c:IsAttribute(attr) and c:IsDefense(1500) and c:IsRace(RACE_SPELLCASTER)
		and c:IsAbleToHand() 
end
function cm.so2(c,e,tp,attr)
	return c:IsAttribute(attr) and c:IsDefense(1500) and c:IsRace(RACE_SPELLCASTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
--Effect 2
function cm.posfilter(c)
	return c:IsFacedown() and c:IsCanChangePosition()
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.posfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	Duel.SelectTarget(tp,cm.posfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsPosition(POS_FACEUP_DEFENSE) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	end
end
